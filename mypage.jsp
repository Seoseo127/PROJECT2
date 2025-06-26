<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="javax.servlet.http.*, javax.servlet.*, java.util.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="model.dto.UserDTO"%>
<c:set var="user" value="${sessionScope.loginUser}" />
<%@ include file="header.jsp"%>

<c:if test="${needLogin == true}">
  <script>
    alert("로그인이 필요한 페이지입니다.");
    location.href = "login.jsp";
  </script>
</c:if>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>마이페이지</title>
<style>
/* 마이페이지 내용 */
.mypage-wrapper {
	text-align: center;
	margin: 100px auto 40px;
}

.info-box {
	border: 1px solid #ccc;
	width: 300px;
	margin: 0 auto 40px;
	padding: 20px;
	border-radius: 10px;
	background: #fff;
	box-shadow: 0px 2px 5px rgba(0, 0, 0, 0.1);
}

.summary-box {
	display: flex;
	justify-content: center;
	gap: 50px;
	margin-bottom: 30px;
}

.summary-item {
	cursor: pointer;
	width: 160px;
	padding: 20px;
	border-radius: 12px;
	background: #fafafa;
	box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
	transition: all 0.2s;
}

.summary-item:hover {
	background: #f0eaea;
	transform: translateY(-3px);
}

.summary-title {
	font-size: 16px;
	font-weight: bold;
}

.summary-line {
	margin: 10px 0;
}

.summary-value {
	font-size: 15px;
}

#activityResult {
	max-width: 700px;
	margin: 0 auto;
}

.btn {
	background-color: #4A2F27;
	color: white;
	border: none;
	padding: 10px 16px;
	border-radius: 8px;
	font-size: 14px;
	cursor: pointer;
	transition: background-color 0.2s ease;
}

.btn:hover {
	background-color: #6e3e34;
}
</style>
</head>
<body>

	<div class="mypage-wrapper">
		<h2>${user.nickname}님의마이페이지</h2>

		<div class="info-box">
			<p>
				<strong>아이디:</strong> ${user.userId}
			</p>
			<p>
				<strong>닉네임:</strong> ${user.nickname}
			</p>
			<p>
				<strong>이메일:</strong> ${user.email}
			</p>
			<p>
				<strong>회원유형:</strong> ${user.userGrade}
			</p>

			<form action="check_pw.jsp" method="get">
				<button type="submit" class="btn">정보 수정</button>
			</form>
		</div>

		<c:choose>
			<c:when test="${param.action eq 'getMyPosts'}">
				<jsp:include page="my_post_list.jsp" />
			</c:when>
			<c:when test="${param.action eq 'getMyComments'}">
				<jsp:include page="my_comment_list.jsp" />
			</c:when>
		</c:choose>

		<div class="summary-box">
			<div class="summary-item" onclick="loadMyPosts()">
				<div class="summary-title">내가 쓴 글</div>
				<hr class="summary-line">
				<div class="summary-value">
					📄 <strong>${postCount != null ? postCount : 0}</strong>개
				</div>
			</div>
			<div class="summary-item" onclick="loadMyComments()">
				<div class="summary-title">내가 쓴 댓글</div>
				<hr class="summary-line">
				<div class="summary-value">
					💬 <strong>${commentCount != null ? commentCount : 0}</strong>개
				</div>
			</div>
		</div>

		<div id="activityResult" class="activity-box">
			<!-- AJAX 결과 삽입 영역 -->
		</div>
	</div>

	<script>
	function loadMyPosts(page = 1) {
		  fetch("user/ajax", {
		    method: "POST",
		    headers: { "Content-Type": "application/x-www-form-urlencoded" },
		    body: "action=getMyPosts&page=" + page
		  })
		  .then(res => res.text())
		  .then(html => {
		    document.getElementById("activityResult").innerHTML = html;
		  });
		}

	function loadMyComments(page = 1) {
		  fetch("user/ajax", {
		    method: "POST",
		    headers: { "Content-Type": "application/x-www-form-urlencoded" },
		    body: "action=getMyComments&page=" + page
		  })
		  .then(res => res.text())
		  .then(html => {
		    document.getElementById("activityResult").innerHTML = html;
		  });
		}
</script>

</body>
</html>