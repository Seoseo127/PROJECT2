package controller.study;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import model.dto.StudyGroupDTO;
import model.dto.StudyMemberDTO;
import service.StudyGroupService;

@WebServlet("/studyDetail")

public class StudyDetailController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private StudyGroupService studyService = new StudyGroupService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int groupId = Integer.parseInt(request.getParameter("groupId"));
        HttpSession session = request.getSession();
        String userId = (String) session.getAttribute("userId");

        StudyGroupDTO group = studyService.getGroupById(groupId);
        List<StudyMemberDTO> members = studyService.getAllMembers(groupId);

        boolean isJoined = members.stream().anyMatch(m -> m.getUserId().equals(userId));
        boolean isLeader = group.getLeaderId().equals(userId);

        request.setAttribute("group", group);
        request.setAttribute("members", members);
        request.setAttribute("isJoined", isJoined);
        request.setAttribute("isLeader", isLeader);

        // ✅ 수정된 경로
        request.getRequestDispatcher("/study_detail.jsp").forward(request, response);
    }
}
