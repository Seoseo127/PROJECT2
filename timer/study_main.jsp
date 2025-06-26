<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<jsp:include page="../header.jsp" />

<html>
<head>
<title>공부 메인</title>
<link rel="stylesheet" href="<c:url value='/css/study_timer.css' />">
<style>
.subject-box {
	margin-bottom: 20px;
	padding: 15px;
	border: 1px solid #ccc;
	border-radius: 12px;
}

.timer-btn {
	margin-top: 30px;
	text-align: center;
}

.timer-btn a button {
	background-color: #4A2F27;
	color: #fff;
	font-weight: bold;
	border: none;
	padding: 10px 20px;
	border-radius: 8px;
	cursor: pointer;
}

.timer-btn a button:hover {
	background-color: #6d4036;
}
</style>
</head>
<body>

	<div class="container">
		<h2>📚 공부 목표 설정</h2>

		<c:if test="${empty sessionScope.loginUser}">
			<p>로그인이 필요합니다.</p>
			<a href="../login.jsp">로그인하러 가기</a>
		</c:if>

		<c:if test="${not empty sessionScope.loginUser}">
			<div class="subject-list">
				<c:forEach var="subject" items="${subjectList}">
					<div class="subject-box">
						<h3>${subject}</h3>

						<form action="save_timer.jsp" method="post">
							<input type="hidden" name="userId"
								value="${sessionScope.loginUser.userId}" /> <input
								type="hidden" name="subject" value="${subject}" /> 목표시간: <input
								type="number" name="goal" min="1" required /> min
							<button type="submit">저장</button>
						</form>
					</div>
				</c:forEach>
			</div>

			<!-- ✅ 타이머 실행 버튼 -->
			<div class="btn-group">
				<a href="study_timer.jsp"><button>⏱️ 타이머 실행</button></a> <a
					href="<c:url value='/TODO/todo_list.jsp' />"><button>🗒️
						할 일 목록</button></a>
			</div>
		</c:if>
	</div>

</body>
</html>
