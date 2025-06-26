<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.Map, java.util.HashMap" %>
<%@ page import="org.apache.ibatis.session.SqlSession, org.apache.ibatis.session.SqlSessionFactory" %>
<%@ page import="util.DBConnection" %>
<%@ page import="java.text.SimpleDateFormat, java.text.ParseException" %> <%-- 날짜 파싱을 위해 추가 --%>
<%-- <%@ page import="java.util.Date" %> --%> <%-- java.util.Date 임포트 제거 (충돌 방지) --%>
<%@ page import="java.sql.Date" %> <%-- java.sql.Date 사용 --%>
<% request.setCharacterEncoding("UTF-8"); %> <%-- POST 데이터 한글 깨짐 방지 --%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>할 일 수정 처리 중...</title> <%-- 처리 중임을 알리는 제목 --%>
</head>
<body>
    <%
        SqlSession sqlSession = null;
        String debugInfo = ""; // 디버깅 정보를 저장할 변수

        try {
            // 폼에서 전송된 데이터 받기
            int todoId = Integer.parseInt(request.getParameter("todoId"));
            String subject = request.getParameter("subject");
            String content = request.getParameter("content");
            String deadlineStr = request.getParameter("deadline"); // "yyyy-MM-dd" 형식의 문자열
            String goal = request.getParameter("goal");

            // 디버깅: 폼에서 받은 마감일 문자열 출력
            System.out.println("editTodoProcess.jsp: Received deadlineStr = " + deadlineStr);
            debugInfo += "Received deadlineStr = " + deadlineStr + "<br>";


            // DEADLINE 문자열을 java.sql.Date 객체로 변환
            java.sql.Date deadline = null;
            if (deadlineStr != null && !deadlineStr.isEmpty()) {
                try {
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                    // java.util.Date 임포트를 제거했으므로 전체 이름 사용
                    java.util.Date utilDate = sdf.parse(deadlineStr);
                    // 디버깅: 파싱된 java.util.Date 객체 출력
                    System.out.println("editTodoProcess.jsp: Parsed utilDate = " + utilDate);
                    debugInfo += "Parsed utilDate = " + utilDate + "<br>";

                    deadline = new java.sql.Date(utilDate.getTime()); // java.util.Date를 java.sql.Date로 변환
                    // 디버깅: 변환된 java.sql.Date 객체 출력
                    System.out.println("editTodoProcess.jsp: Converted sqlDate = " + deadline);
                    debugInfo += "Converted sqlDate = " + deadline + "<br>";

                } catch (ParseException e) {
                    // 날짜 파싱 오류 발생 시 처리
                    System.err.println("editTodoProcess.jsp: Error parsing deadline date: " + deadlineStr);
                    e.printStackTrace();
                    debugInfo += "Error parsing deadline date: " + e.getMessage() + "<br>";
                    // deadline 변수는 null인 상태로 유지됨
                } catch (IllegalArgumentException e) {
                    // new java.sql.Date() 변환 중 Invalid year value 등 발생 시
                    System.err.println("editTodoProcess.jsp: Error converting to sql.Date: " + e.getMessage());
                    e.printStackTrace();
                    debugInfo += "Error converting to sql.Date: " + e.getMessage() + "<br>";
                    // deadline 변수는 null인 상태로 유지됨
                }
            } else {
                 // deadlineStr이 비어있는 경우
                 System.out.println("editTodoProcess.jsp: deadlineStr is empty or null.");
                 debugInfo += "deadlineStr is empty or null.<br>";
            }

            // 디버깅: 최종 deadline 변수 값 출력
            System.out.println("editTodoProcess.jsp: Final deadline value for MyBatis = " + deadline);
            debugInfo += "Final deadline value for MyBatis = " + deadline + "<br>";


            // MyBatis 매퍼에 전달할 파라미터 Map 생성
            java.util.Map<String, Object> params = new java.util.HashMap<>();
            params.put("todoId", todoId); // 수정할 할 일의 ID
            params.put("subject", subject);
            params.put("content", content);
            params.put("deadline", deadline); // 변환된 java.sql.Date 객체 또는 null
            params.put("goal", goal);

            // DBConnection에서 SqlSessionFactory를 가져옴
            SqlSessionFactory factory = DBConnection.getFactory();
            sqlSession = factory.openSession(); // 기본적으로 auto-commit은 false

            // MyBatis 매퍼 호출 (네임스페이스.ID)
            // updateTodo 매퍼는 parameterType="map"으로 정의됨
            int updatedRows = sqlSession.update("PROJECT_2.updateTodo", params);

            // 변경사항 커밋
            sqlSession.commit();

            // 수정 성공 후 목록 페이지로 리다이렉트
            response.sendRedirect("todo_list.jsp");

        } catch (NumberFormatException e) {
             // todoId 파라미터가 숫자가 아닐 경우
            e.printStackTrace();
            debugInfo += "Error parsing todoId: " + e.getMessage() + "<br>";
            out.println("<div style='color: red;'>잘못된 할 일 ID 형식입니다.</div>");
            out.println("<br>디버그 정보:<br>" + debugInfo); // 디버그 정보 출력
            out.println("<br><a href='todo_list.jsp'>목록으로 돌아가기</a>");
        } catch (Exception e) {
            // 예외 발생 시 처리
            e.printStackTrace();
            debugInfo += "General Error: " + e.getMessage() + "<br>";
            // 에러 발생 시 롤백
            if (sqlSession != null) {
                 try { sqlSession.rollback(); } catch(Exception rbEx) { rbEx.printStackTrace(); }
            }
            // 에러 메시지 출력 또는 에러 페이지로 리다이렉트
            out.println("<div style='color: red;'>할 일 수정 중 오류가 발생했습니다: " + e.getMessage() + "</div>");
            out.println("<br>디버그 정보:<br>" + debugInfo); // 디버그 정보 출력
            // 수정 페이지로 돌아가려면 todoId를 다시 넘겨줘야 함
            // out.println("<br><a href='editTodoForm.jsp?todoId=" + request.getParameter("todoId") + "'>다시 수정하기</a>");
            out.println("<br><a href='todo_list.jsp'>목록으로 돌아가기</a>");

        } finally {
            // SqlSession 닫기
            if (sqlSession != null) {
                sqlSession.close();
            }
        }
    %>
</body>
</html>
