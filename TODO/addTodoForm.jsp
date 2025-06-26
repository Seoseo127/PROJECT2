<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="../header.jsp" /> <!-- ✅ 메뉴바 포함 -->

<html>
<head>
    <title>TODO 추가</title>
    <link rel="stylesheet" href="<c:url value='/css/todo_style.css' />"> <!-- 🔧 공통 스타일 -->
</head>
<body>

<div class="container">
    <h2>📝 TODO 추가</h2>

    <!-- ✅ 로그인 확인 -->
    <c:if test="${empty sessionScope.loginUser}">
        <p>로그인이 필요합니다.</p>
        <a href="../login.jsp">로그인하러 가기</a>
    </c:if>

    <c:if test="${not empty sessionScope.loginUser}">
        <form action="addTodoProcess.jsp" method="post">
            <input type="hidden" name="userId" value="${sessionScope.loginUser.userId}" />

            <label for="subject">과목:</label>
            <input type="text" id="subject" name="subject" required /><br/><br/>

            <label for="content">내용:</label><br/>
            <textarea id="content" name="content" rows="4" cols="50" required></textarea><br/><br/>

            <label for="deadline">기한:</label>
            <input type="date" id="deadline" name="deadline" required /><br/><br/>

            <label for="goal">목표 시간 (분):</label>
            <input type="number" id="goal" name="goal" min="1" required /><br/><br/>

            <button type="submit">추가하기</button>
            <a href="todo_list.jsp"><button type="button">취소</button></a>
        </form>
    </c:if>
</div>

</body>
</html>
