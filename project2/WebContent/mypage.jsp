<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.dto.UserDTO" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>마이페이지</title>
  <style>
    body {
      font-family: 'Malgun Gothic', sans-serif;
      text-align: center;
      margin-top: 80px;
    }

    .info-box {
      display: inline-block;
      text-align: left;
      padding: 20px 40px;
      border: 1px solid #ddd;
      border-radius: 10px;
      background-color: #f9f9f9;
    }

    .info-box p {
      margin: 10px 0;
      font-size: 15px;
    }

    .btn {
      margin-top: 20px;
      padding: 8px 16px;
      background-color: #333;
      color: white;
      border: none;
      cursor: pointer;
    }
  </style>
</head>
<body>

<%
  UserDTO loginUser = (UserDTO) session.getAttribute("loginUser");
  if (loginUser == null) {
%>
  <h3>로그인이 필요합니다.</h3>
  <a href="login.jsp">로그인</a>
<%
  } else {
%>

  <h2><%= loginUser.getUserName() %>님의 마이페이지</h2>

  <div class="info-box">
    <p><strong>아이디:</strong> <%= loginUser.getUserId() %></p>
    <p><strong>닉네임:</strong> <%= loginUser.getNickname() %></p>
    <p><strong>이메일:</strong> <%= loginUser.getEmail() %></p>
    <p><strong>회원유형:</strong> <%= loginUser.getUserGrade() %></p>

    <form action="check_pw.jsp" method="get">
      <button type="submit" class="btn">정보 수정</button>
    </form>
  </div>

<%
  }
%>

</body>
</html>