<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>게시글 수정</title>
</head>
<body>
    <h2>게시글 수정</h2>
    <form action="updatePost" method="post">
        <input type="hidden" name="postId" value="${post.postId}" />
        <label>제목: <input type="text" name="title" value="${post.title}" required></label><br/>
        <label>내용: <textarea name="pContent" rows="10" cols="50" required>${post.pContent}</textarea></label><br/>
        <input type="submit" value="수정">
        <input type="button" value="취소" onclick="history.back()">
    </form>
</body>
</html>
