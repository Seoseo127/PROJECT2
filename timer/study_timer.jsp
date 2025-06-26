<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="../header.jsp"/>

<html>
<head>
  <title>공부 타이머</title>
  <link rel="stylesheet" href="<c:url value='/css/study_timer.css' />">
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>

<div class="container">

  <h2>⏱️ 공부 타이머</h2>

  <!-- ✅ 로그인 확인 -->
  <c:if test="${empty sessionScope.loginUser}">
    <p>로그인이 필요합니다.</p>
    <a href="../login.jsp">로그인하러 가기</a>
  </c:if>

  <c:if test="${not empty sessionScope.loginUser}">
    <!-- 총 공부 시간 출력 -->
    <div class="total-time">
      총 공부 시간: <span id="totalTime">0분</span>
    </div>

    <!-- 과목별 타이머 출력 -->
    <div class="timer-wrapper">
      <c:forEach var="subject" items="${subjectList}">
        <div class="subject-timer" data-subject="${subject}">
          <h3>${subject}</h3>
          <div class="timer" id="timer-${subject}">00:00:00</div>

          <!-- 목표 시간 입력 -->
          <form action="save_timer.jsp" method="post" class="goal-form">
            <input type="hidden" name="userId" value="${sessionScope.loginUser.userId}" />
            <input type="hidden" name="subject" value="${subject}" />
            목표시간: 
            <input type="number" name="goal" min="1" required /> min
            <button type="submit">저장</button>
          </form>

          <!-- 타이머 제어 버튼 -->
          <div class="controls">
            <button class="start-btn" data-subject="${subject}">시작</button>
            <button class="pause-btn" data-subject="${subject}">일시정지</button>
            <button class="stop-btn" data-subject="${subject}">정지</button>
          </div>
        </div>
      </c:forEach>
    </div>
  </c:if>

</div>

<script src="js/study_timer.js"></script> <!-- 🔧 타이머 제어 스크립트 -->
<script>
  // AJAX로 총 공부시간 불러오기
  $(document).ready(function () {
    $.get("get_total_study_time.jsp", function (data) {
      $("#totalTime").text(data + "분");
    });
  });
</script>

</body>
</html>
