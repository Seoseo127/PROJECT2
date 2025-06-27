package controller.community;

import java.io.IOException;
import java.util.*;
import java.util.stream.Collectors;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import model.dto.PostDTO;
import service.PostService;

@WebServlet("/CommunityListController")
public class CommunityListController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// ✅ 파라미터 받기 및 공백 제거
		String category = request.getParameter("category");
		if (category == null || category.trim().equals("")) {
			category = "all";
		} else {
			category = category.trim(); // ← 여기 추가 (핵심!!)
		}

		String keyword = request.getParameter("keyword");
		if (keyword == null) keyword = "";

		int page = 1;
		int limit = 10;
		if (request.getParameter("page") != null) {
			page = Integer.parseInt(request.getParameter("page"));
		}
		int offset = (page - 1) * limit;

		PostService postService = new PostService();
		List<PostDTO> postList;
		List<PostDTO> topPosts;
		int totalCount;

		// ✅ 학생 카테고리 목록 정의
		List<String> studentCategories = List.of("고등학생", "대학생", "취준생", "직장인");

		// ✅ 카테고리 분기 처리
		if ("학생".equals(category)) {
		    // 전체 학생별 게시글 목록
		    postList = postService.getPostsByCategories(studentCategories, keyword, offset, limit);
		    totalCount = postService.getTotalPostCountByCategories(studentCategories, keyword);
		    topPosts = List.of(); // 인기글 제외

		} else if (studentCategories.contains(category)) {
		    // 각 학생 구분 탭 (고등학생/취준생 등)
		    postList = postService.getPostsWithPaging(category, keyword, offset, limit);
		    totalCount = postService.getTotalPostCount(category, keyword);
		    topPosts = postService.getTopPostsByCategory(category);

		} else {
		    // 일반 게시판 (자유, 공부, 전체)
		    postList = postService.getPostsWithPaging(category, keyword, offset, limit);
		    totalCount = postService.getTotalPostCount(category, keyword);

		    if ("all".equals(category)) {
		        topPosts = postService.getTopPosts();
		    } else {
		        topPosts = postService.getTopPostsByCategory(category);
		    }
		}

		// ✅ 인기글 제외한 나머지 일반 글 추출
		Set<Integer> topIds = topPosts.stream().map(PostDTO::getPostId).collect(Collectors.toSet());
		List<PostDTO> restPosts = postList.stream()
			.filter(p -> !topIds.contains(p.getPostId()))
			.collect(Collectors.toList());

		int totalPages = (int) Math.ceil((double) totalCount / limit);

		// ✅ request에 담아서 포워딩
		request.setAttribute("postList", postList);
		request.setAttribute("topPosts", topPosts);
		request.setAttribute("currentPage", page);
		request.setAttribute("totalPages", totalPages);
		request.setAttribute("category", category);
		request.setAttribute("keyword", keyword);

		request.getRequestDispatcher("community.jsp").forward(request, response);
	}
}
