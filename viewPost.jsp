<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page
	import="java.util.*, model.dto.PostDTO, model.dto.CommentDTO, model.dto.UserDTO"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%
PostDTO post = (PostDTO) request.getAttribute("post");
List<CommentDTO> commentList = (List<CommentDTO>) request.getAttribute("commentList");
String userId = (String) session.getAttribute("userId");

if (userId == null && session.getAttribute("loginUser") != null) {
	userId = ((UserDTO) session.getAttribute("loginUser")).getUserId();
}

String writerId = post.getUserId();
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 보기</title>
<style>
.post-box, .comment-box {
	width: 80%;
	margin: auto;
	margin-bottom: 20px;
	padding: 15px;
	border: 1px solid #ddd;
	border-radius: 6px;
}

.btn {
	padding: 6px 12px;
	border-radius: 4px;
	background-color: #4CAF50;
	color: white;
	border: none;
}

.btn:hover {
	background-color: #45a049;
}

.comment-form textarea {
	width: 100%;
	height: 60px;
}

.action-buttons {
	text-align: right;
	margin-top: 10px;
}

.post-box {
  position: relative; /* 자식의 absolute 기준점이 됨 */
}

.view-count-box {
  position: absolute;
  top: 15px;
  right: 20px;
  padding: 6px 10px;
  background-color: #eee;
  border: 1px solid #ccc;
  border-radius: 4px;
  font-size: 13px;
  color: #333;
}



</style>
</head>
<body>

	<div class="post-box">
		<h2><%=post.getTitle()%></h2>
		<p>
			작성자:
			<%=writerId%></p>
		<p><%=post.getpContent()%></p>
		<p>
			작성일시:
			<%=post.getCreatedAt()%></p>
			
		<!-- ✅ 여기에 조회수 표시 추가 -->
		
		<div class="view-count-box">
 		 👁️ 조회수: <%=post.getViewCount()%>
</div>


		<%
		if (post.getFilePath() != null && !post.getFilePath().isEmpty()) {
		%>
		<%
		if ("image".equals(post.getFileType())) {
		%>
		<div>
			<img src="<%=request.getContextPath() + "/" + post.getFilePath()%>"
				width="400">
		</div>
		<%
		} else if ("video".equals(post.getFileType())) {
		%>
		<div>
			<video width="400" controls>
				<source
					src="<%=request.getContextPath() + "/" + post.getFilePath()%>">
			</video>
		</div>
		<%
		} else {
		%>
		<p>
			첨부파일: <a
				href="<%=request.getContextPath() + "/" + post.getFilePath()%>"
				target="_blank">파일 보기</a>
		</p>
		<%
		}
		%>
		<%
		}
		%>

		<div class="action-buttons">
			<%
			if (userId != null && userId.equals(writerId)) {
			%>
			<form action="editPostForm.do" method="get" style="display: inline;">
				<input type="hidden" name="postId" value="<%=post.getPostId()%>">
				<button type="submit" class="btn">수정</button>
			</form>
			<form action="deletePost.do" method="post" style="display: inline;"
				onsubmit="return confirm('정말 삭제하시겠습니까?');">
				<input type="hidden" name="postId" value="<%=post.getPostId()%>">
				<button type="submit" class="btn" style="background-color: red;">삭제</button>
			</form>
			<%
			}
			%>

			<form action="CommunityListController" method="get"
				style="display: inline;">
				<input type="hidden" name="category" value="all"> <input
					type="hidden" name="keyword" value="">
				<button type="submit" class="btn">목록으로</button>
			</form>
		</div>

		<!-- ✅ 좋아요 버튼 (하트 + 숫자 표시) -->
		<div class="action-buttons" style="margin-top: 15px;">
			<c:if test="${not empty sessionScope.loginUser}">
				<form action="likePost" method="post" style="display: inline;">
					<input type="hidden" name="postId" value="${post.postId}" />
					<c:choose>
						<c:when test="${hasLiked == 1}">
							<button type="submit" class="btn" style="background-color: pink;"> ❤️
								${post.likeCount}</button>
						</c:when>
						<c:otherwise>
							<button type="submit" class="btn"
								style="background-color: lightgray;"> 🤍
								${post.likeCount}</button>
						</c:otherwise>
					</c:choose>

				</form>
			</c:if>
		</div>
	</div>

	<div class="comment-box">
		<h3>댓글</h3>

		<form action="addComment" method="post" class="comment-form">
			<input type="hidden" name="postId" value="<%=post.getPostId()%>">
			<textarea name="cContent" required></textarea>
			<br />
			<button type="submit" class="btn">댓글 작성</button>
		</form>

		<hr />

		<%
		if (commentList != null && !commentList.isEmpty()) {
			for (CommentDTO comment : commentList) {
		%>
		<div style="margin-bottom: 10px;">
			<p>
				<strong><%=comment.getUserId()%></strong>:
				<%=comment.getcContent()%></p>
			<p><%=comment.getCreatedAt()%></p>

			<%
			if (userId != null && userId.equals(comment.getUserId())) {
			%>
			<form action="updateComment" method="post" style="display: inline;">
				<input type="hidden" name="commentId"
					value="<%=comment.getCommentId()%>"> <input type="hidden"
					name="postId" value="<%=post.getPostId()%>"> <input
					type="text" name="cContent" value="<%=comment.getcContent()%>"
					required>
				<button type="submit" class="btn">수정</button>
			</form>
			<form action="deleteComment" method="post" style="display: inline;">
				<input type="hidden" name="commentId"
					value="<%=comment.getCommentId()%>"> <input type="hidden"
					name="postId" value="<%=post.getPostId()%>">
				<button type="submit" class="btn" style="background-color: red;">삭제</button>
			</form>
			<%
			}
			%>
		</div>
		<hr />
		<%
		}
		} else {
		%>
		<p>댓글이 없습니다.</p>
		<%
		}
		%>
	</div>

</body>
</html>
