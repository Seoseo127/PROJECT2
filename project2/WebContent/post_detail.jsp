<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="model.dto.PostDTO" %>

<html>
<head>
    <title>게시글 상세</title>
</head>
<body>
<%
    PostDTO post = (PostDTO) request.getAttribute("post");
    if (post == null) {
%>
    <p>게시글이 없습니다.</p>
<%
    } else {
%>
    <h2><%= post.getTitle() %></h2>
    <p>작성자: <%= post.getUserId() %></p>
    <p>카테고리: <%= post.getCategory() %></p>
    <p>작성일: <%= post.getCreatedAt() %></p>
    <hr/>
    <p><%= post.getPContent() %></p>
<%
    }
%>
<a href="posts?action=list&category=전체게시판">목록으로</a>
</body>
</html>
