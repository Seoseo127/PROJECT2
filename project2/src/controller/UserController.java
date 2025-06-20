package controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.dto.UserDTO;
import service.UserService;

@WebServlet("/user/*")
public class UserController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		req.setCharacterEncoding("UTF-8");
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

		// 📌 로그인 처리
		else if (uri.endsWith("/login")) {
			String userId = extractValue(body, "userId");
			String password = extractValue(body, "password");

			UserDTO loginUser = service.login(userId, password);

			if (loginUser != null) {
				req.getSession().setAttribute("loginUser", loginUser);
				out.print("{\"success\": true, \"message\": \"로그인 성공\"}");
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
		} else if (uri.endsWith("/checkpw")) {
			String password = extractValue(body, "password");
			UserDTO loginUser = (UserDTO) req.getSession().getAttribute("loginUser");

			boolean result = false;

			if (loginUser != null && loginUser.getPassword().equals(password)) {
				result = true;
				req.getSession().setAttribute("checkPassed", true); // ✅ 인증 성공 플래그
			}

			out.print("{\"success\": " + result + "}");
		}
		// ✒️회원정보 수정
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
				req.getSession().removeAttribute("checkPassed"); // ⛔ 인증은 한번만
			}

			out.print("{\"success\": " + result + ", \"message\": \"" + (result ? "수정 완료" : "수정 실패") + "\"}");
		}
		// ❌회원탈퇴
		else if (uri.endsWith("/delete")) {
			String userId = extractValue(body, "userId");
			boolean result = service.deleteUser(userId);

			if (result) {
				req.getSession().invalidate(); // ✅ 세션 초기화 → 자동 로그아웃
			}

			out.print("{\"success\": " + result + ", \"message\": \"" + (result ? "회원 탈퇴 완료" : "탈퇴 실패") + "\"}");
		}

	}

	// 유틸: JSON 문자열에서 특정 키의 값 추출
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