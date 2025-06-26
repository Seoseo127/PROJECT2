<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.dto.PostDTO" %>
<%
    PostDTO post = (PostDTO) request.getAttribute("post");
%>
<!DOCTYPE html>
<html>
<head>
    <title>게시글 수정</title>
</head>
<body>
<h2>게시글 수정</h2>

<!-- ✅ URL 매핑 수정: updatePost.do -->
<form action="updatePost.do" method="post" enctype="multipart/form-data">
    <input type="hidden" name="postId" value="<%= post.getPostId() %>">

    <label>제목</label><br>
    <input type="text" name="title" value="<%= post.getTitle() %>" required><br><br>

    <label>내용</label><br>
    <textarea name="pContent" rows="10" cols="50" required><%= post.getpContent() %></textarea><br><br>

    <label>첨부파일 (이미지/영상)</label><br>
    <input type="file" name="uploadFile" accept="image/*,video/*"><br><br>

    <!-- ✅ 기존 첨부파일 출력 -->
    <% if (post.getFilePath() != null && !post.getFilePath().isEmpty()) { %>
        <p>현재 첨부파일:</p>
        <% if ("image".equals(post.getFileType())) { %>
            <img src="<%= request.getContextPath() + "/" + post.getFilePath() %>" width="300">
        <% } else if ("video".equals(post.getFileType())) { %>
            <video width="400" controls>
                <source src="<%= request.getContextPath() + "/" + post.getFilePath() %>">
            </video>
        <% } else { %>
            <a href="<%= request.getContextPath() + "/" + post.getFilePath() %>" target="_blank">파일 보기</a>
        <% } %>
    <% } %>

    <br><br>
    <input type="submit" value="수정 완료">
</form>

<!-- 목록으로 이동 -->
<form action="CommunityListController" method="get" style="margin-top: 10px;">
    <input type="hidden" name="category" value="all">
    <input type="hidden" name="keyword" value="">
    <button type="submit">목록으로</button>
</form>

</body>
</html>
