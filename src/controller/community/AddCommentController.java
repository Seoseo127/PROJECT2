package controller.community;

import model.dto.CommentDTO;
import model.dto.NotificationDTO;
import model.dto.PostDTO;
import model.dto.UserDTO;
import service.CommentService;
import service.NotificationService;
import service.PostService;
import websocket.NotificationWebSocket;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/addComment")
public class AddCommentController extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        UserDTO loginUser = (UserDTO) session.getAttribute("loginUser");

        // 로그인 안 된 경우 리다이렉트
        if (loginUser == null) {
            int postId = Integer.parseInt(request.getParameter("postId"));
            response.sendRedirect("ViewPostController?postId=" + postId);
            return;
        }

        int postId = Integer.parseInt(request.getParameter("postId"));
        String userId = loginUser.getUserId(); // 세션에서 로그인한 유저 ID
        String cContent = request.getParameter("cContent");

        // 댓글 등록
        CommentDTO comment = new CommentDTO();
        comment.setPostId(postId);
        comment.setUserId(userId);
        comment.setcContent(cContent);

        new CommentService().addComment(comment);

        // 알림 대상 게시글 불러오기
        PostDTO post = new PostService().getPostById(postId);
        
        System.out.println("post.getUserId() = " + post.getUserId());


        // 댓글 알림
        String nickname = loginUser.getNickname(); // ✅ 한 번만 선언 (블록 밖)

        if (post != null && !userId.equals(post.getUserId())) {
            NotificationDTO noti = new NotificationDTO();
            noti.setUserId(post.getUserId());      // 알림 받을 사용자 (글 작성자)
            noti.setPostId(postId);
            noti.setType("댓글");
            noti.setMessage(nickname + "님이 내 글에 댓글을 남겼습니다.");

            new NotificationService().addNotification(noti);

            // ✅ 실시간 웹소켓 알림도 조건문 안에서 함께 보내는 게 안전함
            NotificationWebSocket.sendNotification(
                post.getUserId(),
                nickname + "님이 내 글에 댓글을 남겼습니다."
            );
        }

    


        // 댓글 작성 후 게시글로 리다이렉트
        response.sendRedirect("ViewPostController?postId=" + postId);
    }
}
