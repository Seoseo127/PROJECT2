<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
<head>
    <title>게시글 목록</title>
</head>
<body>

<h2>게시글 목록</h2>

<c:if test="${empty posts}">
    <p>게시글이 없습니다.</p>
</c:if>

<c:forEach var="post" items="${posts}">
    <div style="border:1px solid #ccc; margin-bottom:10px; padding:10px;">
        <h3><a href="posts?action=view&postId=${post.postId}">${post.title}</a></h3>
        <p>작성자: ${post.userId} | 카테고리: ${post.category}</p>
        <p>${post.pContent}</p>
    </div>
</c:forEach>

<a href="post_write.jsp">글쓰기</a>

</body>
</html>
