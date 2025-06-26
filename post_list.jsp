<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, model.dto.PostDTO" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    List<PostDTO> postList = (List<PostDTO>) request.getAttribute("postList");
    String category = request.getParameter("category");
    String keyword = request.getParameter("keyword");
    if (category == null) category = "all";
    if (keyword == null) keyword = "";
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>게시판</title>
    <style>
        body {
            font-family: 'Malgun Gothic';
            max-width: 800px;
            margin: auto;
            padding: 20px;
        }
        .btn-group {
            margin-bottom: 20px;
        }
        .btn-group form {
            display: inline-block;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }
        th, td {
            padding: 10px;
            border-bottom: 1px solid #ccc;
            text-align: left;
        }
        .search-form {
            margin-bottom: 20px;
        }
        .search-form input[type="text"] {
            padding: 5px;
            width: 200px;
        }
        .search-form button {
            padding: 6px 10px;
        }
        .action-bar {
            text-align: right;
        }
    </style>
</head>
<body>

<h2>📚 커뮤니티 게시판</h2>

<!-- ✅ 카테고리 버튼 -->
<div class="btn-group">
    <form action="CommunityListController" method="get">
        <input type="hidden" name="category" value="all">
        <button type="submit">전체글</button>
    </form>
    <form action="CommunityListController" method="get">
        <input type="hidden" name="category" value="자유">
        <button type="submit">자유게시판</button>
    </form>
    <form action="CommunityListController" method="get">
        <input type="hidden" name="category" value="공부">
        <button type="submit">공부게시판</button>
    </form>
    <form action="CommunityListController" method="get">
        <input type="hidden" name="category" value="학생별">
        <button type="submit">학생별게시판</button>
    </form>
</div>

<!-- ✅ 검색 & 글쓰기 버튼 -->
<div class="action-bar">
    <form class="search-form" action="CommunityListController" method="get" style="display:inline;">
        <input type="hidden" name="category" value="<%= category %>">
        <input type="text" name="keyword" placeholder="검색어" value="<%= keyword %>">
        <button type="submit">검색</button>
    </form>

    <form action="writePost.jsp" method="get" style="display:inline;">
        <button type="submit">글쓰기</button>
    </form>
</div>

<!-- ✅ 게시글 목록 테이블 -->
<table>
    <t
    r>
        <th>번호</th>
        <th>카테고리</th>
        <th>제목</th>
        <th>작성자</th>
        <th>작성일</th>
        <th>댓글수</th>
        <th>조회수</th> 
    </tr>
    
    <!-- ✅ 1. 인기글 먼저 출력 -->
	<c:forEach var="post" items="${topPosts}">
 	 <tr style="background-color: #fff9e6;"> <!-- 인기글 강조색 -->
    <td>${post.postId}</td>
    <td>${post.category}</td>
    <td><a href="ViewPostController?postId=${post.postId}">🔥 ${post.title}</a></td>
    <td>${post.userId}</td>
    <td>${post.createdAt}</td>
    <td>${post.commentCount}</td>
    <td>${post.viewCount}</td>
  </tr>
</c:forEach>


<%
    if (postList != null && !postList.isEmpty()) {
        for (PostDTO post : postList) {
%>
    <tr>
        <td><%= post.getPostId() %></td>
        <td><%= post.getCategory() %></td>
        <td>
            <a href="ViewPostController?postId=<%= post.getPostId() %>">
                <%= post.getTitle() %>
            </a>
        </td>
        <td><%= post.getUserId() %></td>
        <td><%= post.getCreatedAt() %></td>
        <td><%= post.getCommentCount() %></td>
        <td><%= post.getViewCount() %></td>
    </tr>
<%
        }
    } else {
%>
    <tr>
    
        <td colspan="6" style="text-align:center;">게시글이 없습니다.</td>
    </tr>
<%

    }
%>
</table>

</body>
</html>
