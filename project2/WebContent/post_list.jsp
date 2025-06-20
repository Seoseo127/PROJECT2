 <%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>게시글 목록</title>
</head>
<body>
    <h1>커뮤니티 게시글</h1>

    <form action="posts" method="get">
        <select name="category">
            <option value="">전체게시판</option>
            <option value="공부">공부게시판</option>
            <option value="자유">자유게시판</option>
            <option value="학생별">학생별게시판</option>
        </select>
        <input type="text" name="search" placeholder="검색어 입력">
        <button type="submit">검색</button>
    </form>

    <hr/>

   <form action="posts" method="post">
    <p>작성자: <strong><%= session.getAttribute("UserId") %></strong></p> <%-- 사용자에게 보여주기만 --%>
    
    <select name="category">
        <option value="공부">공부게시판</option>
        <option value="자유">자유게시판</option>
        <option value="학생별">학생별게시판</option>
    </select><br>
    
    <input type="text" name="title" placeholder="제목" required><br>
    
    <textarea name="pContent" placeholder="내용 작성" rows="5" cols="40" required></textarea><br>
    
    <button type="submit">작성하기</button>
</form>


    <hr/>

    <table border="1">
        <thead>
        <tr>
            <th>번호</th>
            <th>카테고리</th>
            <th>제목</th>
            <th>작성자</th>
            <th>작성일</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="post" items="${posts}">
            <tr>
                <td>${post.postId}</td>
                <td>${post.category}</td>
                <td>${post.title}</td>
                <td>${post.userId}</td>
                <td>${post.createdAt}</td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</body>