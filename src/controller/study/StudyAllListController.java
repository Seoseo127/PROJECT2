package controller.study;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import model.dto.StudyGroupDTO;
import service.StudyGroupService;

@WebServlet("/allGroups")
public class StudyAllListController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private StudyGroupService studyService = new StudyGroupService();

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// 페이지 번호 처리
		int page = 1;
		int itemsPerPage = 5;

		if (request.getParameter("page") != null) {
			try {
				page = Integer.parseInt(request.getParameter("page"));
			} catch (NumberFormatException e) {
				page = 1;
			}
		}

		// 전체 그룹 가져오기
		List<StudyGroupDTO> allGroups = studyService.getAllGroups();

		int totalItems = allGroups.size();
		int totalPages = (int) Math.ceil((double) totalItems / itemsPerPage);

		int fromIndex = (page - 1) * itemsPerPage;
		int toIndex = Math.min(fromIndex + itemsPerPage, totalItems);
		List<StudyGroupDTO> pagedList = allGroups.subList(fromIndex, toIndex);

		request.setAttribute("groups", pagedList);
		request.setAttribute("currentPage", page);
		request.setAttribute("totalPages", totalPages);

		// 참여 그룹, 생성 그룹도 넘기고 있다면
		HttpSession session = request.getSession();
		String userId = (String) session.getAttribute("userId");

		request.setAttribute("groupsLedByMe", studyService.getGroupsLedByUser(userId));
		request.setAttribute("groupsJoinedByMe", studyService.getGroupsJoinedByUser(userId));

		request.getRequestDispatcher("/study_main.jsp").forward(request, response);
	}
}
