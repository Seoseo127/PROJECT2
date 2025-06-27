package controller.community;

import model.dto.UserDTO;
import model.dto.PostDTO;
import service.PostService;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.*;

@WebServlet("/scrap")
public class ScrapController extends HttpServlet {
    private final PostService postService = new PostService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/plain; charset=UTF-8");

        HttpSession session = req.getSession();
        UserDTO loginUser = (UserDTO) session.getAttribute("loginUser");

        // ✅ 로그인 체크
        if (loginUser == null) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            resp.getWriter().write("로그인이 필요합니다.");
            return;
        }

        // ✅ 파라미터 받기
        String postIdStr = req.getParameter("postId");
        String addStr = req.getParameter("add");

        try {
            int postId = Integer.parseInt(postIdStr);
            boolean add = Boolean.parseBoolean(addStr);

            Map<String, Object> param = new HashMap<>();
            param.put("userId", loginUser.getUserId());
            param.put("postId", postId);

            // ✅ 등록 또는 취소
            if (add) {
                postService.scrapPost(param);
                resp.getWriter().write("스크랩 완료");
            } else {
                postService.unscrapPost(param);
                resp.getWriter().write("스크랩 취소됨");
            }

        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("잘못된 요청입니다.");
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        UserDTO loginUser = (UserDTO) session.getAttribute("loginUser");

        // ✅ 로그인 안 된 경우 로그인 페이지로 리다이렉트
        if (loginUser == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        // ✅ 내가 스크랩한 게시글 목록 조회
        List<PostDTO> scrapList = postService.getMyScrapPosts(loginUser.getUserId());
        req.setAttribute("scrapList", scrapList);

        // ✅ 스크랩 목록 JSP로 포워딩
        req.getRequestDispatcher("my_scrap_list.jsp").forward(req, resp);
    }
}
