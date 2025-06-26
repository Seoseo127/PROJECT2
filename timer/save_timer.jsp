<%@ page contentType="text/plain; charset=UTF-8" %>
<%@ page import="service.TimerService" %>

<%
String result = "FAIL";
try {
    request.setCharacterEncoding("UTF-8");

    String userId = request.getParameter("userId");
    String subject = request.getParameter("subject");
    String goalStr = request.getParameter("goal");

    if (userId != null && subject != null && goalStr != null) {
        int goal = Integer.parseInt(goalStr);
        TimerService service = new TimerService();
        boolean success = service.saveGoalTime(userId, subject, goal);
        if (success) result = "SUCCESS";
    }
} catch (Exception e) {
    result = "ERROR";
}
out.print(result);
%>
