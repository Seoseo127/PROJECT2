<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
request.setCharacterEncoding("UTF-8");
%>
<%@ page import="org.apache.ibatis.session.*, util.DBConnection, java.util.*"%>
<%
request.setCharacterEncoding("UTF-8");
String userId = request.getParameter("userId");
String subject = request.getParameter("subject");

SqlSession sqlSession = null;
try {
    sqlSession = DBConnection.getFactory().openSession();

    // 1. TODO_LIST 테이블의 STATUS를 '완료'로 업데이트
    Map<String, Object> todoParams = new HashMap<>();
    todoParams.put("userId", userId);
    todoParams.put("subject", subject);
    sqlSession.update("PROJECT_2.updateTodoStatusToCompleted", todoParams); // ✅ PROJECT_2 네임스페이스 사용

    // 2. STUDY_TIMER 테이블의 CLEAR 컬럼을 현재 날짜로 업데이트
    Map<String, Object> timerParams = new HashMap<>();
    timerParams.put("userId", userId);
    timerParams.put("subject", subject);
    sqlSession.update("TIMER.updateStudyTimerClearDate", timerParams); // ✅ TIMER 네임스페이스 사용

    sqlSession.commit(); // 두 업데이트 모두 성공해야 커밋
    out.print("success");

} catch (Exception e) {
    e.printStackTrace();
    if (sqlSession != null) {
        sqlSession.rollback(); // 오류 발생 시 롤백
    }
    out.print("fail");
} finally {
    if (sqlSession != null) {
        sqlSession.close();
    }
}
%>
