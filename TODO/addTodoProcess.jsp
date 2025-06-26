<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.apache.ibatis.session.*" %>
<%@ page import="util.DBConnection" %>
<%@ page import="java.util.*, java.text.SimpleDateFormat" %>
<%@ page import="java.sql.Date" %>
<%
request.setCharacterEncoding("UTF-8");
SqlSession sqlSession = null;
try {
    String userId = request.getParameter("userId");
    String subject = request.getParameter("subject");
    String content = request.getParameter("content");
    String deadlineStr = request.getParameter("deadline");
    String goal = request.getParameter("goal");
    String goalTimeStr = request.getParameter("goalTime");

    Date deadline = null;
    if (deadlineStr != null && !deadlineStr.isEmpty()) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        java.util.Date utilDate = sdf.parse(deadlineStr);
        deadline = new Date(utilDate.getTime());
    }

    int goalTime = 0;
    if (goalTimeStr != null && !goalTimeStr.isEmpty()) {
        goalTime = Integer.parseInt(goalTimeStr);
    }

    Map<String, Object> todoParams = new HashMap<>();
    todoParams.put("userId", userId);
    todoParams.put("subject", subject);
    todoParams.put("content", content);
    todoParams.put("deadline", deadline);
    todoParams.put("goal", goal);

    Map<String, Object> timerParams = new HashMap<>();
    timerParams.put("userId", userId);
    timerParams.put("subject", subject);
    timerParams.put("totalMinutes", goalTime);

    SqlSessionFactory factory = DBConnection.getFactory();
    sqlSession = factory.openSession();

    // ✅ 제목 중복 체크
    int count = sqlSession.selectOne("PROJECT_2.checkSubjectDuplicate", todoParams);
    if (count > 0) {
%>
        <script>
            alert("중복입니다. 제목을 다르게 입력해주세요.");
            history.back();
        </script>
<%
    } else {
        // TODO_LIST 저장
        sqlSession.insert("PROJECT_2.insertTodo", todoParams);

        // STUDY_TIMER 저장 또는 업데이트 (MERGE)
        sqlSession.insert("TIMER.insertOrUpdateGoalTime", timerParams);

        sqlSession.commit();
        response.sendRedirect("todo_list.jsp");
    }
} catch (Exception e) {
    if (sqlSession != null) sqlSession.rollback();
    e.printStackTrace();
%>
    <script>
        alert("저장 중 오류 발생: <%= e.getMessage() %>");
        history.back();
    </script>
<%
} finally {
    if (sqlSession != null) sqlSession.close();
}
%>
