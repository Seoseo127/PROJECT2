<%@ page contentType="text/html; charset=UTF-8" language="java" %>

<html>
<head>
    <title>글쓰기</title>
</head>
<body>
<h2>새 게시글 작성</h2>

<form action="posts" method="post">
    <label for="user_id">작성자:</label><br/>
    <input type="text" id="user_id" name="user_id" required/><br/><br/>

    <label for="category">카테고리:</label><br/>
    <input type="text" id="category" name="category" required/><br/><br/>

    <label for="title">제목:</label><br/>
    <input type="text" id="title" name="title" required/><br/><br/>

    <label for="p_content">내용:</label><br/>
    <textarea id="p_content" name="p_content" rows="10" cols="50" required></textarea><br/><br/>

    <button type="submit">등록</button>
</form>

<a href="posts">목록으로</a>

</body>
</html>
