package controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import model.dto.PostDTO;
import service.PostService;

@WebServlet("/posts")
public class PostController extends HttpServlet {
    private PostService service = new PostService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<PostDTO> posts = service.getAllPosts();
        req.setAttribute("posts", posts);
        req.getRequestDispatcher("/post_list.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            // 로그인 안 됐으면 로그인 페이지로 이동 또는 에러 처리
            resp.sendRedirect("/PROJECT_2/login.jsp");
            return;
        }

        String userId = (String) session.getAttribute("userId");

        PostDTO post = new PostDTO();
        post.setUserId(userId);  // 세션에서 가져온 userId 사용
        post.setCategory(req.getParameter("category"));
        post.setTitle(req.getParameter("title"));
        post.setpContent(req.getParameter("pContent"));

        service.addPost(post);
        resp.sendRedirect("/PROJECT_2/posts");
    }

    }

