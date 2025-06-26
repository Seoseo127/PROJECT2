<%@ page contentType="text/plain; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.apache.ibatis.session.*, util.DBConnection, java.util.*, java.sql.Date"%>
<%
request.setCharacterEncoding("UTF-8");

String userId = request.getParameter("userId");
String todoIdStr = request.getParameter("todoId");
String subject = request.getParameter("subject"); // subject 파라미터 받기

SqlSession sqlSession = null;
try {
    int todoId = Integer.parseInt(todoIdStr);
    sqlSession = DBConnection.getFactory().openSession();

    // 1. TODO_LIST 테이블 STATUS를 '완료'로 변경
    Map<String, Object> todoParams = new HashMap<>();
    todoParams.put("todoId", todoId);
    todoParams.put("userId", userId); // userId도 조건에 포함
    // subject도 조건에 포함 (필요하다면)
    // todoParams.put("subject", subject); 
    sqlSession.update("PROJECT_2.updateTodoStatusToCompletedByTodoId", todoParams); // 새로운 매퍼 ID

    // 2. STUDY_TIMER 테이블 CLEAR 컬럼에 현재 날짜 입력
    // (subject와 userId를 기준으로 업데이트)
    Map<String, Object> timerParams = new HashMap<>();
    timerParams.put("userId", userId);
    timerParams.put("subject", subject);
    timerParams.put("clearDate", new java.sql.Date(System.currentTimeMillis())); // 현재 날짜
    sqlSession.update("TIMER.updateStudyTimerClearDateBySubject", timerParams); // 새로운 매퍼 ID

    sqlSession.commit();
    out.print("success");

} catch (Exception e) {
    e.printStackTrace();
    if (sqlSession != null) {
        sqlSession.rollback();
    }
    out.print("fail");
} finally {
    if (sqlSession != null) {
        sqlSession.close();
    }
}
%>
