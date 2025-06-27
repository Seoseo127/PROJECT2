package controller.community;

import java.net.URLEncoder; //추가


import model.dto.PostDTO;
import service.PostService;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.nio.file.Paths;

@WebServlet("/community/write")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,     // 1MB
    maxFileSize = 10 * 1024 * 1024,      // 10MB
    maxRequestSize = 50 * 1024 * 1024    // 50MB
)
public class CreatePostController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        // ✅ 업로드 경로 설정
        String uploadPath = req.getServletContext().getRealPath("/upload");
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdirs();

        // ✅ 파일 파트 처리
        Part filePart = req.getPart("uploadFile");
        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        String filePath = null;
        String fileType = null;

        if (fileName != null && !fileName.isEmpty()) {
            filePart.write(uploadPath + File.separator + fileName);
            filePath = "upload/" + fileName; // 웹 접근용 상대 경로
            fileType = filePart.getContentType();
        }

        // ✅ 폼 파라미터 처리
        String userId = req.getParameter("userId");
        String category = req.getParameter("category"); // 고등학생 / 대학생 / 자유 / 공부 등
        String title = req.getParameter("title");
        String pContent = req.getParameter("pContent");

        // ✅ DTO 생성
        PostDTO dto = new PostDTO();
        dto.setUserId(userId);
        dto.setCategory(category); // ✅ 반드시 저장
        dto.setTitle(title);
        dto.setpContent(pContent);
        dto.setFilePath(filePath);
        dto.setFileType(fileType);

        // ✅ DB 등록
        boolean result = new PostService().createPost(dto);

        // ✅ 성공 시 해당 게시판으로 이동
     // ✅ 성공 시 해당 게시판으로 이동 (한글 인코딩 처리)
        if (result) {
            String encodedCategory = URLEncoder.encode(category, "UTF-8");
            resp.sendRedirect(req.getContextPath() + "/CommunityListController?category=" + encodedCategory);
        }
        else {
            resp.setContentType("text/html; charset=UTF-8");
            PrintWriter out = resp.getWriter();
            out.println("<script>alert('등록 실패'); history.back();</script>");
        }
    }
}
