package controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import model.dto.CommentDTO;
import model.dto.PostDTO;
import model.dto.UserDTO;
import service.CommentService;
import service.PostService;
import service.UserService;

@WebServlet("/user/*")
public class UserController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	// ✅ 마이페이지 접속 시 글/댓글 개수 세팅
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		HttpSession session = req.getSession();
		UserDTO loginUser = (UserDTO) session.getAttribute("loginUser");

		if (loginUser == null) {
		    req.setAttribute("needLogin", true);
		    req.getRequestDispatcher("/mypage.jsp").forward(req, resp);
		    return;
		}

		String userId = loginUser.getUserId();

		PostService postService = new PostService();
		CommentService commentService = new CommentService();

		int postCount = postService.getMyPostCount(userId);
		int commentCount = commentService.getMyCommentCount(userId);

		req.setAttribute("postCount", postCount);
		req.setAttribute("commentCount", commentCount);

		req.getRequestDispatcher("/mypage.jsp").forward(req, resp);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		req.setCharacterEncoding("UTF-8");

		String action = req.getParameter("action");
		if (action != null) {
			resp.setContentType("text/html;charset=UTF-8");

			UserDTO loginUser = (UserDTO) req.getSession().getAttribute("loginUser");
			PostService postService = new PostService();
			CommentService commentService = new CommentService();

			if ("getMyPosts".equals(action)) {
				String userId = loginUser.getUserId();

				// 페이징 파라미터 처리
				int page = 1;
				int limit = 4;
				try {
					page = Integer.parseInt(req.getParameter("page"));
				} catch (Exception e) {
					// 기본값 사용
				}
				int offset = (page - 1) * limit;

				int totalCount = postService.getMyPostCount(userId);
				int totalPages = (int) Math.ceil((double) totalCount / limit);

				Map<String, Object> paramMap = new HashMap<>();
				paramMap.put("userId", userId);
				paramMap.put("offset", offset);
				paramMap.put("limit", limit);

				List<PostDTO> list = postService.getMyPostsPaging(paramMap);
				req.setAttribute("postList", list);
				req.setAttribute("totalPages", totalPages);
				req.setAttribute("currentPage", page);
				req.getRequestDispatcher("/my_post_list.jsp").forward(req, resp);
				return;
			} else if ("getMyComments".equals(action)) {
				String userId = loginUser.getUserId();
				int page = 1;
				int limit = 4;

				if (req.getParameter("page") != null) {
					page = Integer.parseInt(req.getParameter("page"));
				}
				int offset = (page - 1) * limit;

				int total = commentService.getMyCommentCount(userId);
				int totalPages = (int) Math.ceil((double) total / limit);

				List<CommentDTO> commentList = commentService.getMyCommentsWithPaging(userId, offset, limit);

				req.setAttribute("commentList", commentList);
				req.setAttribute("currentPage", page);
				req.setAttribute("totalPages", totalPages);
				req.getRequestDispatcher("/my_comment_list.jsp").forward(req, resp);
				return;
			}
		}

		// ✨ JSON 처리 (로그인/회원가입 등)
		resp.setContentType("application/json;charset=UTF-8");

		String uri = req.getRequestURI();

		BufferedReader reader = new BufferedReader(new InputStreamReader(req.getInputStream(), "UTF-8"));
		StringBuilder sb = new StringBuilder();
		String line;
		while ((line = reader.readLine()) != null) {
			sb.append(line);
		}
		String body = sb.toString();

		UserService service = new UserService();
		PrintWriter out = resp.getWriter();

		// 📌 회원가입 처리
		if (uri.endsWith("/signup")) {
			String userId = extractValue(body, "userId");
			String password = extractValue(body, "password");
			String nickname = extractValue(body, "nickname");
			String email = extractValue(body, "email");
			String userName = extractValue(body, "userName");
			String userGrade = extractValue(body, "userGrade");

			UserDTO dto = new UserDTO(userId, password, nickname, email, userName, userGrade);
			boolean result = service.signup(dto);

			out.print("{\"success\": " + result + ", \"message\": \"" + (result ? "회원가입 성공" : "회원가입 실패") + "\"}");
		}

		// 📌 로그인 처리 (userName 포함 응답)
		else if (uri.endsWith("/login")) {
		    String userId = extractValue(body, "userId");
		    String password = extractValue(body, "password");

		    UserDTO loginUser = service.login(userId, password);

		    if (loginUser != null) {
		        HttpSession session = req.getSession();
		        session.setAttribute("loginUser", loginUser);
		        session.setAttribute("userId", loginUser.getUserId()); // ✅ 추가: 게시글 수정/삭제 버튼용

		        String userName = loginUser.getUserName();
		        String json = String.format("{\"success\": true, \"message\": \"로그인 성공\", \"userName\": \"%s\"}", userName);
		        out.print(json);
		    } else {
		        out.print("{\"success\": false, \"message\": \"아이디 또는 비밀번호가 틀렸습니다.\"}");
		    }
		}


		// 🔑 비밀번호 찾기
		else if (uri.endsWith("/findpw")) {
			String userId = extractValue(body, "userId");
			String email = extractValue(body, "email");

			String pw = service.findPassword(userId, email);

			if (pw != null) {
				out.print("{\"success\": true, \"message\": \"비밀번호는 " + pw + " 입니다.\"}");
			} else {
				out.print("{\"success\": false, \"message\": \"일치하는 회원 정보가 없습니다.\"}");
			}
		}

		// ✅ 비밀번호 확인
		else if (uri.endsWith("/checkpw")) {
			String password = extractValue(body, "password");
			UserDTO loginUser = (UserDTO) req.getSession().getAttribute("loginUser");

			boolean result = false;

			if (loginUser != null && loginUser.getPassword().equals(password)) {
				result = true;
				req.getSession().setAttribute("checkPassed", true); // 인증 성공 플래그
			}

			out.print("{\"success\": " + result + "}");
		}

		// ✒️ 회원정보 수정
		else if (uri.endsWith("/update")) {
			String userId = extractValue(body, "userId");
			String password = extractValue(body, "password");
			String nickname = extractValue(body, "nickname");

			UserDTO dto = new UserDTO();
			dto.setUserId(userId);
			dto.setPassword(password);
			dto.setNickname(nickname);

			boolean result = service.updateUser(dto);

			if (result) {
				UserDTO updatedUser = service.login(userId, password);
				req.getSession().setAttribute("loginUser", updatedUser);
				req.getSession().removeAttribute("checkPassed"); // 인증은 한번만
			}

			out.print("{\"success\": " + result + ", \"message\": \"" + (result ? "수정 완료" : "수정 실패") + "\"}");
		}

		// ❌ 회원 탈퇴
		else if (uri.endsWith("/delete")) {
			String userId = extractValue(body, "userId");
			boolean result = service.deleteUser(userId);

			if (result) {
				req.getSession().invalidate(); // 세션 초기화 → 자동 로그아웃
			}

			out.print("{\"success\": " + result + ", \"message\": \"" + (result ? "회원 탈퇴 완료" : "탈퇴 실패") + "\"}");
		}
		// 로그아웃
		else if (uri.endsWith("/logout")) {
		    req.getSession().invalidate(); // 세션 초기화
		    // 로그아웃 완료 표시용 파라미터 전달
		    resp.sendRedirect(req.getContextPath() + "/login.jsp?logout=true");
		}

	}

	// 🔧 JSON 문자열에서 특정 키의 값을 추출하는 유틸 메서드
	private String extractValue(String json, String key) {
		String target = "\"" + key + "\":";
		int start = json.indexOf(target);
		if (start == -1)
			return null;

		int valueStart = json.indexOf("\"", start + target.length()) + 1;
		int valueEnd = json.indexOf("\"", valueStart);
		return json.substring(valueStart, valueEnd);
	}
}
