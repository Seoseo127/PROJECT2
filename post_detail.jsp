<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>게시글 상세</title>
  <style>
    body {
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      background-color: #f4f4f4;
      margin: 0;
      padding: 20px;
      color: #333;
    }

    .container {
      max-width: 800px;
      margin: 0 auto;
      background-color: #fff;
      padding: 30px;
      border-radius: 16px;
      box-shadow: 0 8px 24px rgba(0, 0, 0, 0.1);
    }

    .post-title {
      font-size: 2rem;
      font-weight: 700;
      text-align: center;
      margin-bottom: 30px;
      color: #2c2c2c;
      border-bottom: 2px solid #ddd;
      padding-bottom: 20px;
    }

    .post-info {
      display: grid;
      grid-template-columns: 120px 1fr;
      row-gap: 10px;
      column-gap: 10px;
      margin-bottom: 25px;
      margin-top: 0;
    }

    .post-info .label {
      font-weight: 600;
      color: #666;
      text-align: right;
      padding-right: 10px;
    }

    .post-info .value {
      color: #222;
    }

    .post-content {
      background-color: #f9f9f9;
      padding: 20px 25px;
      border-radius: 12px;
      border: 1.5px solid #ccc;
      line-height: 1.7;
      white-space: pre-line;
      font-size: 1rem;
    }

    .btn-box {
      margin-top: 40px;
      display: flex;
      justify-content: space-between;
      align-items: center;
    }

    .left-buttons,
    .right-buttons {
      display: flex;
      gap: 10px;
    }

    .btn-box a {
      padding: 12px 24px;
      background-color: #333;
      color: #fff;
      text-decoration: none;
      border-radius: 8px;
      font-weight: 600;
      transition: background-color 0.3s;
    }

    .btn-box a:hover {
      background-color: #111;
    }

    @media (max-width: 600px) {
      .post-info {
        grid-template-columns: 1fr;
      }
      .post-info .label {
        text-align: left;
        padding: 0;
      }
      .btn-box {
        flex-direction: column;
        align-items: stretch;
        gap: 10px;
      }
      .left-buttons, .right-buttons {
        justify-content: flex-start;
      }
    }
  </style>
</head>
<body>

  <div class="container">
    <div class="post-title">${post.title}</div>

    <div class="post-info">
      <div class="label">작성자</div>
      <div class="value">${post.userId}</div>

      <div class="label">카테고리</div>
      <div class="value">${post.category}</div>

      <div class="label">작성일</div>
      <div class="value">${post.createdAt}</div>
    </div>

    <div class="post-content">
      ${post.pContent}
    </div>

    <div class="btn-box">
      <div class="left-buttons">
        <a href="post_list.jsp?category=${post.category}">목록으로</a>
      </div>
      <div class="right-buttons">
        <a href="post_edit.jsp?postId=${post.postId}">수정</a>
        <a href="post_delete.jsp?postId=${post.postId}" onclick="return confirm('정말 삭제하시겠습니까?');">삭제</a>
      </div>
    </div>
  </div>

</body>
</html>
