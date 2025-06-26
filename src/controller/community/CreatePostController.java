package controller.community;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.dto.PostDTO;
import service.PostService;

@WebServlet("/community/write")
public class CreatePostController extends HttpServlet {
  private static final long serialVersionUID = 1L;

  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    req.setCharacterEncoding("UTF-8");
    resp.setContentType("application/json; charset=UTF-8");

    // JSON 문자열 수동 파싱
    BufferedReader reader = new BufferedReader(new InputStreamReader(req.getInputStream(), "UTF-8"));
    StringBuilder sb = new StringBuilder();
    String line;
    while ((line = reader.readLine()) != null) {
      sb.append(line);
    }
    String body = sb.toString();

    // 직접 값 추출
    String userId = extractValue(body, "userId");
    String category = extractValue(body, "category");
    String title = extractValue(body, "title");
    String pContent = extractValue(body, "pContent");

    // DTO 생성
    PostDTO dto = new PostDTO();
    dto.setUserId(userId);
    dto.setCategory(category);
    dto.setTitle(title);
    dto.setpContent(pContent);

    // 서비스 호출
    boolean result = new PostService().createPost(dto);

    // 응답 출력
    PrintWriter out = resp.getWriter();
    out.print("{\"success\": " + result + ", \"message\": \"" + (result ? "등록 완료" : "등록 실패") + "\"}");
  }

  // JSON 문자열에서 특정 키의 값 추출하는 유틸
  private String extractValue(String json, String key) {
    String target = "\"" + key + "\":";
    int start = json.indexOf(target);
    if (start == -1) return null;

    int valueStart = json.indexOf("\"", start + target.length()) + 1;
    int valueEnd = json.indexOf("\"", valueStart);
    return json.substring(valueStart, valueEnd);
  }
}