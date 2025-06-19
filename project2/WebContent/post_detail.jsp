<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>게시글 상세</title>
    <style>
        .post { margin: 20px 0; padding: 15px; border: 1px solid #ddd; }
        .comments { margin: 20px 0; }
        .comment { border-bottom: 1px solid #eee; padding: 10px 0; }
        .comment-form { margin: 20px 0; }
    </style>
</head>
<body>
    <h1>게시글 상세</h1>
    <div class="post">
        <h2>${post.title}</h2>
        <p><strong>카테고리:</strong> ${post.category}</p>
        <p><strong>작성자:<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>게시글 상세</title>
    <style>
        .post { margin: 20px 0; padding: 15px; border: 1px solid #ddd; }
        .comments { margin: 20px 0; }
        .comment { border-bottom: 1px solid #eee; padding: 10px 0; }
        .comment-form { margin: 20px 0; }
    </style>
</head>
<body>
    <h1>게시글 상세</h1>
    <div class="post">
        <h2>${post.title}</h2>
        <p><strong>카테고리:</strong> ${post.category}</p>
        <p><strong>작성자:</strong> ${post.userId}</p>
        <p><strong>작성일:</strong> ${post.createdAt}</p>
        <p>${post.content}</p>
    </div>

    <h3>댓글</h3>
    <div class="comments">
        <c:forEach var="comment" items="${comments}">
            <div class="comment">
                <p><strong>${comment.userId}</strong> (${comment.createdAt})</p>
                <p>${comment.content}</p>
                <c:if test="${sessionScope.userId == comment.userId}">
                    <a href="${pageContext.request.contextPath}/comment/delete?commentId=${comment.commentId}&postId=${post.postId}">삭제</a>
                </c:if>
            </div>
        </c:forEach>
    </div>

    <div class="comment-form">
        <h4>댓글 작성</h4>
        <form action="${pageContext.request.contextPath}/comment/add" method="post">
            <input type="hidden" name="postId" value="${post.postId}">
            <textarea name="content" rows="4" cols="50" placeholder="댓글을 입력하세요" required></textarea><br>
            <input type="submit" value="작성">
        </form>
    </div>

    <a href="${pageContext.request.contextPath}/post_list.jsp">목록으로</a>
</body>
</html></strong> ${post.userId}</p>
        <p><strong>작성일:</strong> ${post.createdAt}</p>
        <p>${post.content}</p>
    </div>

    <h3>댓글</h3>
    <div class="comments">
        <c:forEach var="comment" items="${comments}">
            <div class="comment">
                <p><strong>${comment.userId}</strong> (${comment.createdAt})</p>
                <p>${comment.content}</p>
                <c:if test="${sessionScope.userId == comment.userId}">
                    <a href="${pageContext.request.contextPath}/comment/delete?commentId=${comment.commentId}&postId=${post.postId}">삭제</a>
                </c:if>
            </div>
        </c:forEach>
    </div>

    <div class="comment-form">
        <h4>댓글 작성</h4>
        <form action="${pageContext.request.contextPath}/comment/add" method="post">
            <input type="hidden" name="postId" value="${post.postId}">
            <textarea name="content" rows="4" cols="50" placeholder="댓글을 입력하세요" required></textarea><br>
            <input type="submit" value="작성">
        </form>
    </div>

    <a href="${pageContext.request.contextPath}/post_list.jsp">목록으로</a>
</body>
</html>