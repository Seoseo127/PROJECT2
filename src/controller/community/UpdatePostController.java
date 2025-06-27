package controller.community;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;
import model.dto.PostDTO;
import model.dto.UserDTO;
import service.PostService;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.File;
import java.io.IOException;

@WebServlet("/updatePost.do")
public class UpdatePostController extends HttpServlet {
    private final PostService postService = new PostService();

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        UserDTO loginUser = (UserDTO) session.getAttribute("loginUser");

        if (loginUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // ✅ WebContent 경로에 직접 저장되도록 수정
        String baseUploadPath = request.getServletContext().getRealPath("/") + "upload";
        String subDir = ""; // 하위 디렉토리: upload_image, upload_video
        String fileType = null;
        String filePath = null;

        int maxSize = 10 * 1024 * 1024; // 10MB

        // 먼저 upload 폴더 존재 확인 및 생성
        File uploadRoot = new File(baseUploadPath);
        if (!uploadRoot.exists()) uploadRoot.mkdirs();

        // multipart 파싱
        MultipartRequest multi = new MultipartRequest(
                request, baseUploadPath, maxSize, "UTF-8", new DefaultFileRenamePolicy());

        String postIdStr = multi.getParameter("postId");
        String title = multi.getParameter("title");
        String pContent = multi.getParameter("pContent");
        String category = multi.getParameter("category");
        String fileName = multi.getFilesystemName("uploadFile");

        System.out.println("📎 전달받은 파일명: " + fileName);

        // 파일 확장자 확인 및 하위 디렉토리 지정
        if (fileName != null) {
            String lower = fileName.toLowerCase();
            if (lower.endsWith(".jpg") || lower.endsWith(".jpeg") || lower.endsWith(".png")) {
                fileType = "image";
                subDir = "upload_image";
            } else if (lower.endsWith(".mp4") || lower.endsWith(".avi")) {
                fileType = "video";
                subDir = "upload_video";
            } else {
                fileType = "etc";
                subDir = "etc";
            }

            // 하위 폴더 생성
            String fullUploadPath = baseUploadPath + File.separator + subDir;
            File subFolder = new File(fullUploadPath);
            if (!subFolder.exists()) subFolder.mkdirs();

         // 파일 이동
            File src = new File(baseUploadPath + File.separator + fileName);
            File dest = new File(subFolder, fileName);
            boolean moved = src.renameTo(dest);
            System.out.println("📂 파일 이동 성공 여부: " + moved);
            if (!moved) {
                filePath = "upload/" + fileName;  // fallback 경로
                subDir = "";
                System.out.println("⚠️ 파일 이동 실패! 기본 upload 폴더 경로로 설정");
            } else {
                filePath = "upload/" + subDir + "/" + fileName;
            }
        }

        // DTO 세팅
        PostDTO post = new PostDTO();
        post.setTitle(title);
        post.setpContent(pContent);
        post.setUserId(loginUser.getUserId());

        if (filePath != null) {
            post.setFilePath(filePath);
            post.setFileType(fileType);
        }

        if (postIdStr == null || postIdStr.trim().isEmpty()) {
            // 등록
            post.setCategory(category);
            postService.insertPost(post);
            response.sendRedirect("CommunityListController");

        } else {
            // 수정
            int postId = Integer.parseInt(postIdStr);
            post.setPostId(postId);
            post.setCategory(category);

            // ✅ 새 파일이 없으면 기존 게시글의 filePath, fileType 유지
            if (filePath == null) {
                PostDTO origin = postService.getPostById(postId);
                post.setFilePath(origin.getFilePath());
                post.setFileType(origin.getFileType());
            }

            postService.updatePost(post);
            response.sendRedirect("ViewPostController?postId=" + postId);
        }

    }
}

