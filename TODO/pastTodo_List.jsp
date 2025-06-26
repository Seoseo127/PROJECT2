<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="../header.jsp" />

<html>
<head>
    <title>완료한 TODO 목록</title>
    <link rel="stylesheet" href="<c:url value='/css/todo_style.css' />">
    <style>
        .feedback-textarea {
            width: 200px;
            height: 80px;
            font-size: 13px;
        }
        .alert-success {
            background-color: #dff0d8;
            color: #3c763d;
            padding: 8px;
            border-radius: 6px;
            margin: 10px 0;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>✅ 완료한 TODO 목록</h2>

    <!-- ✅ 피드백 수정 성공 메시지 -->
    <c:if test="${param.updated eq 'true'}">
        <div class="alert-success">피드백이 성공적으로 수정되었습니다.</div>
    </c:if>

    <c:if test="${empty sessionScope.loginUser}">
        <p>로그인이 필요합니다.</p>
        <a href="../login.jsp">로그인하러 가기</a>
    </c:if>

    <c:if test="${not empty sessionScope.loginUser}">
        <table border="1" cellpadding="10" cellspacing="0">
            <thead>
            <tr>
                <th>과목</th>
                <th>내용</th>
                <th>기한</th>
                <th>목표시간</th>
                <th>실제공부시간</th>
                <th>상태</th>
                <th>작성일</th>
                <th>피드백</th>
                <th>삭제</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="todo" items="${pastTodoList}">
                <tr>
                    <td>${todo.subject}</td>
                    <td>${todo.content}</td>
                    <td>${todo.deadline}</td>
                    <td>${todo.goal}분</td>
                    <td>${todo.total}분</td>
                    <td>${todo.status}</td>
                    <td>${todo.createdAt}</td>

                    <!-- ✅ 피드백 수정폼 -->
                    <td>
                        <c:if test="${sessionScope.loginUser.userId == todo.userId}">
                            <form action="feedback" method="post">
                                <input type="hidden" name="todoId" value="${todo.todoId}" />
                                <input type="hidden" name="userId" value="${sessionScope.loginUser.userId}" />
                                <textarea name="feedback" class="feedback-textarea">${todo.feedback}</textarea><br/>
                                <button type="submit">수정</button>
                            </form>
                        </c:if>
                        <c:if test="${sessionScope.loginUser.userId != todo.userId}">
                            ${todo.feedback}
                        </c:if>
                    </td>

                    <td>
                        <form action="deleteTodoProcess.jsp" method="post">
                            <input type="hidden" name="todoId" value="${todo.todoId}" />
                            <button type="submit">삭제</button>
                        </form>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>

        <br/>
        <a href="todo_list.jsp"><button>TODO 목록으로</button></a>
    </c:if>
</div>

</body>
</html>
