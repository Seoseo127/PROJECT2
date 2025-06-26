package controller;

import service.TimerService;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/save_timer")
public class TimerController extends HttpServlet {
    private final TimerService service = new TimerService();

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/plain; charset=UTF-8");

        String userId = request.getParameter("userId");
        String subject = request.getParameter("subject");
        String goalStr = request.getParameter("goal");

        String result = "FAIL";

        try {
            if (userId != null && subject != null && goalStr != null) {
                int goal = Integer.parseInt(goalStr);
                boolean success = service.saveGoalTime(userId, subject, goal);
                if (success) result = "SUCCESS";
            }
        } catch (Exception e) {
            result = "ERROR";
            e.printStackTrace();
        }

        response.getWriter().print(result);
    }

    // 추가: 공부시간 누적 저장 또는 삭제 등도 처리 가능
}
