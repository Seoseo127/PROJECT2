<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link rel="stylesheet" href="<c:url value='/css/menu_bar.css' />">

<!-- ✅ 메뉴바 전체 -->
<div class="menu-bar-wrapper">

  <!-- ✅ 알림 아이콘 + 팝업 -->
  <div class="noti-wrapper">
    <div class="noti-icon" onclick="toggleNotiPopup()" style="position: relative;">
      <span class="noti-bell">🔔</span>
      <c:if test="${notiCount > 0}">
        <span class="noti-dot" id="notiDot" style="display:inline;">●</span>
        <span class="noti-badge" id="notiCount">${notiCount}</span>
      </c:if>
      <c:if test="${notiCount == 0}">
        <span class="noti-dot" id="notiDot" style="display:none;">●</span>
        <span class="noti-badge" id="notiCount" style="display:none;">0</span>
      </c:if>
    </div>

    <!-- ✅ 알림 팝업 -->
    <div class="noti-popup" id="notiPopup">
      <c:forEach var="n" items="${notifications}" varStatus="status">
        <c:if test="${status.count <= 3}">
          <div class="noti-item">
            <a href="ViewPostController?postId=${n.postId}&notiId=${n.notiId}">
              [${n.type}] ${n.message}
            </a>
          </div>
        </c:if>
      </c:forEach>
      <div class="noti-more">
        <a href="<c:url value='/NotificationController' />">전체 알림 보기</a>
      </div>
    </div>
  </div>



  <!-- ✅ 가운데 정렬된 메뉴 카드들 -->
  <div class="menu-items">
    <a href="<c:url value='/timer/study_main.jsp' />" class="menu-card">
      <span class="menu-text">공부</span>
      <img src="<c:url value='/images/study.png' />" class="menu-icon" />
    </a>
    <a href="<c:url value='/stats.jsp' />" class="menu-card">
      <span class="menu-text">통계</span>
      <img src="<c:url value='/images/Calander.png' />" class="menu-icon" />
    </a>
    <a href="<c:url value='/CommunityListController?category=all' />" class="menu-card">
      <span class="menu-text">커뮤니티</span>
      <img src="<c:url value='/images/commu.png' />" class="menu-icon" />
    </a>
    <a href="<c:url value='/user' />" class="menu-card">
      <span class="menu-text">마이페이지</span>
      <img src="<c:url value='/images/profile.png' />" class="menu-icon" />
    </a>
  </div>

  <!-- ✅ 오른쪽 닉네임 + 로그아웃 or 로그인 -->
  <div class="user-box">
    <c:if test="${not empty sessionScope.loginUser}">
      <span class="nickname-text">${sessionScope.loginUser.nickname}님</span>
      <form action="<c:url value='/user/logout' />" method="post" class="logout-form">
        <button type="submit" class="logout-btn">로그아웃</button>
      </form>
    </c:if>
    <c:if test="${empty sessionScope.loginUser}">
      <a href="<c:url value='/login.jsp' />" class="login-btn">로그인</a>
    </c:if>
  </div>

  <!-- ✅ JS : 팝업 토글 + 외부 클릭 시 닫기 -->
  <script>
  function toggleNotiPopup() {
    const popup = document.getElementById("notiPopup");
    const dot = document.getElementById("notiDot");
    popup.style.display = popup.style.display === "block" ? "none" : "block";
    if (popup.style.display === "block") {
      dot.style.display = "none";
    }
  }

  document.addEventListener("click", function(e) {
    const popup = document.getElementById("notiPopup");
    const icon = document.querySelector(".noti-icon");
    if (!icon.contains(e.target)) {
      popup.style.display = "none";
    }
  });

  // ✅ 웹소켓 연결 및 수신 처리
  const socket = new WebSocket("ws://" + location.host + "/PROJECT_2/notificationSocket");

  socket.onopen = function () {
    const userId = "${sessionScope.loginUser.userId}";
    console.log("🧪 웹소켓 연결 확인 userId:", userId);
    if (userId) {
      console.log("🔗 웹소켓 연결됨, userId 전송:", userId);
      socket.send(userId);
    } else {
      console.warn("⚠️ userId 없음 → 웹소켓 등록 실패");
    }
  };

  socket.onmessage = function (e) {
    const message = e.data;
    console.log("✅ 웹소켓 알림 수신됨:", message);

    // 빨간 점 표시
    const dot = document.getElementById("notiDot");
    if (dot) {
      dot.style.display = "inline";
    }

    // 뱃지 증가
    const badge = document.getElementById("notiCount");
    if (badge) {
      let count = parseInt(badge.innerText || "0");
      count++;
      badge.innerText = count;
      badge.style.display = "inline-block";
    }

    // 팝업에 알림 추가
    const popup = document.getElementById("notiPopup");
    if (popup) {
      const item = document.createElement("div");
      item.className = "noti-item";
      item.innerHTML = `<a href="<c:url value='/NotificationController' />">[실시간] ${message}</a>`;
      popup.prepend(item);
    }
  };
  </script>
</div>
