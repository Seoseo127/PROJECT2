<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<jsp:include page="../header.jsp" />

<html>
<head>
  <title>TODO 목록</title>
  <link rel="stylesheet" href="<c:url value='/css/todo_style.css' />">
  <style>
    .badge {
      display: inline-block;
      padding: 4px 8px;
      border-radius: 8px;
      font-size: 12px;
      font-weight: bold;
      color: #fff;
    }

    .badge-warning {
      background-color: #f0ad4e;
    }

    .badge-success {
      background-color: #5cb85c;
    }
  </style>
</head>
<body>

<div class="container">
  <h2>📋 TODO 목록</h2>

  <c:if test="${not empty sessionScope.loginUser}">
    <a href="<c:url value='/TODO/addTodoForm.jsp' />"><button>+ 할 일 추가</button></a>
    <a href="<c:url value='/todo?action=past' />"><button>완료된 할 일 보기</button></a>
  </c:if>

  <table border="1" cellpadding="10" cellspacing="0">
    <thead>
    <tr>
      <th>과목</th>
      <th>내용</th>
      <th>기한</th>
      <th>목표시간</th>
      <th>상태</th>
      <th>관리</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach var="todo" items="${todoList}">
      <tr>
        <td>${todo.subject}</td>
        <td>${todo.content}</td>
        <td>${todo.deadline}</td>
        <td>${todo.goal}분</td>

        <!-- ✅ 상태 Badge -->
        <td>
          <c:choose>
            <c:when test="${todo.status eq '완료'}">
              <span class="badge badge-success">완료</span>
            </c:when>
            <c:otherwise>
              <span class="badge badge-warning">진행중</span>
            </c:otherwise>
          </c:choose>
        </td>

        <td>
          <form action="<c:url value='/todo' />" method="get" style="display: inline;">
            <input type="hidden" name="action" value="edit" />
            <input type="hidden" name="todoId" value="${todo.todoId}" />
            <button type="submit">수정</button>
          </form>
          <form action="<c:url value='/todo' />" method="post" style="display: inline;">
            <input type="hidden" name="action" value="complete" />
            <input type="hidden" name="todoId" value="${todo.todoId}" />
            <button type="submit">완료</button>
          </form>
        </td>
      </tr>
    </c:forEach>
    </tbody>
  </table>
</div>

</body>
</html>
