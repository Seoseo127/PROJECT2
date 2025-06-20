<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>로그인</title>
  <style>
    body {
      margin: 0;
      font-family: 'Malgun Gothic', sans-serif;
      background-color: #fff;
      text-align: center;
    }

    .container {
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      height: 100vh;
    }

    .logo {
      width: 240px;
      margin-bottom: 40px;
    }

    .login-box {
      width: 240px;
    }

    input[type="text"], input[type="password"] {
      width: 100%;
      padding: 10px;
      margin-bottom: 10px;
      border: 1px solid #ccc;
      font-size: 14px;
      border-radius: 4px;
    }

    button {
      width: 100%;
      padding: 10px;
      background-color: #333;
      color: #fff;
      border: none;
      font-size: 14px;
      border-radius: 4px;
      cursor: pointer;
    }

    .link-area {
      margin-top: 12px;
      font-size: 12px;
    }

    .link-area a {
      color: #007bff;
      text-decoration: none;
      margin: 0 5px;
    }
  </style>
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
  <div class="container">
    <img src="images/logo.png" class="logo" alt="로고 이미지"> <!-- 로고 이미지 경로 -->
    
    <form id="loginForm" class="login-box">
      <input type="text" name="userId" placeholder="아이디" required>
      <input type="password" name="password" placeholder="비밀번호" required>
      <button type="submit">로그인</button>
      <div class="link-area">
        <a href="find_pw.jsp">비밀번호 찾기</a> 
        <a href="signup.jsp">회원가입</a>
      </div>
    </form>
  </div>

  <script>
    $("#loginForm").on("submit", function(e) {
      e.preventDefault();
      const data = {
        userId: $("input[name=userId]").val(),
        password: $("input[name=password]").val()
      };

      $.ajax({
        url: "user/login",
        method: "POST",
        contentType: "application/json",
        data: JSON.stringify(data),
        success: function(res) {
          alert(res.message);
          if (res.success) {
            location.href = "mypage.jsp";
          }
        }
      });
    });
  </script>
</body>
</html>
