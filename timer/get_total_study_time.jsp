<%@ page contentType="text/plain; charset=UTF-8" %>
<%@ page import="service.TimerService" %>
<%@ page import="model.dto.UserDTO" %>

<%
int total = 0;
try {
    UserDTO loginUser = (UserDTO) session.getAttribute("loginUser");
    if (loginUser != null) {
        String userId = loginUser.getUserId();
        TimerService service = new TimerService();
        total = service.getTotalStudyMinutes(userId);
    }
} catch (Exception e) {
    total = -1;
}
out.print(total);
%>
