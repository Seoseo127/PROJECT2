package controller;

import model.dto.PostDTO;
import service.PostService;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.util.List;

// /posts?action=list&category=전체글
@WebServlet("/posts")
public class PostController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        String category = request.getParameter("category");
        if (category == null) {
            category = "전체글";  // 기본값 지정!
        }

        Connection conn = (Connection) request.getServletContext().getAttribute("conn"); // 이미 있는 유틸 연결 사용

        PostService service = new PostService(conn);

        try {
            if ("list".equals(action)) {
                List<PostDTO> posts = service.list(category);
                request.setAttribute("posts", posts);
                request.getRequestDispatcher("/view/post_list.jsp").forward(request, response);

            } else if ("view".equals(action)) {
                int postId = Integer.parseInt(request.getParameter("postId"));
                PostDTO post = service.detail(postId);
                request.setAttribute("post", post);
                request.getRequestDispatcher("/view/post_view.jsp").forward(request, response);

            } else if ("search".equals(action)) {
                String keyword = request.getParameter("keyword");
                List<PostDTO> posts = service.search(category, keyword);
                request.setAttribute("posts", posts);
                request.getRequestDispatcher("/view/post_list.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace(); // 개발용 로그
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        Connection conn = (Connection) request.getServletContext().getAttribute("conn");
        PostService service = new PostService(conn);

        try {
            PostDTO post = new PostDTO();
            post.setUserId(request.getParameter("user_id"));       // ✔ 바뀜
            post.setCategory(request.getParameter("category"));
            post.setTitle(request.getParameter("title"));
            post.setPContent(request.getParameter("p_content"));   // ✔ 바뀜

            System.out.println(">> 저장할 내용: " + post.getTitle() + ", " + post.getPContent());

            service.write(post);

            response.sendRedirect("/posts?action=list&category=" + post.getCategory());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
