// ViewPostController.java - 좋아요 상태까지 반영된 게시글 보기
package controller.community;

import model.dto.*;
import service.*;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.*;

@WebServlet("/ViewPostController")
public class ViewPostController extends HttpServlet {
    private final PostService postService = new PostService();
    private final CommentService commentService = new CommentService();
    private final NotificationService notificationService = new NotificationService();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int postId = Integer.parseInt(request.getParameter("postId"));
        String userId = (String) request.getSession().getAttribute("userId");

        // ✅ 알림 ID가 있으면 해당 알림만 읽음 처리
        String notiIdStr = request.getParameter("notiId");
        if (notiIdStr != null) {
            try {
                int notiId = Integer.parseInt(notiIdStr);
                notificationService.markAsReadById(notiId);
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }

        // ✅ 조회수 증가 (좋아요 리다이렉트 제외)
        boolean noCount = "true".equals(request.getParameter("noCount"));
        if (!noCount) {
            postService.increaseViewCount(postId);
        }

        // ✅ 게시글 불러오기
        PostDTO post = postService.getPostById(postId);
        if (post.getpContent() != null) {
            String content = post.getpContent().replace("\\n", "\n");
            post.setpContent(content.replace("\n", "<br/>"));
        }

        // ✅ 댓글 불러오기
        List<CommentDTO> comments = commentService.getCommentsByPostId(postId);
        if (comments == null) comments = new ArrayList<>();

        // ✅ 좋아요 수
        int likeCount = postService.getLikeCount(postId);
        post.setLikeCount(likeCount);

        // ✅ 좋아요 여부
        int hasLiked = 0;
        if (userId != null) {
            Map<String, Object> param = new HashMap<>();
            param.put("postId", postId);
            param.put("userId", userId);
            hasLiked = postService.hasLiked(param);
        }

        // ✅ 데이터 전달
        request.setAttribute("post", post);
        request.setAttribute("commentList", comments);
        request.setAttribute("hasLiked", hasLiked);

        request.getRequestDispatcher("viewPost.jsp").forward(request, response);
    }
}
