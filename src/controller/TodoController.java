package controller;

import model.dto.TodoDTO;
import service.TodoService;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/todo")
public class TodoController extends HttpServlet {
    private final TodoService service = new TodoService();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        String userId = ((model.dto.UserDTO) session.getAttribute("loginUser")).getUserId();

        if ("list".equals(action)) {
            List<TodoDTO> todoList = service.getTodoList(userId);
            request.setAttribute("todoList", todoList);
            request.getRequestDispatcher("TODO/todo_list.jsp").forward(request, response);
        } else if ("past".equals(action)) {
            List<TodoDTO> pastList = service.getCompletedTodoList(userId);
            request.setAttribute("pastTodoList", pastList);
            request.getRequestDispatcher("TODO/pastTodo_List.jsp").forward(request, response);
        } else if ("edit".equals(action)) {
            int todoId = Integer.parseInt(request.getParameter("todoId"));
            TodoDTO todo = service.getTodoById(todoId);
            request.setAttribute("todo", todo);
            request.getRequestDispatcher("TODO/editTodoForm.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        request.setCharacterEncoding("UTF-8");

        if ("add".equals(action)) {
            TodoDTO dto = new TodoDTO();
            dto.setUserId(request.getParameter("userId"));
            dto.setSubject(request.getParameter("subject"));
            dto.setContent(request.getParameter("content"));
            dto.setDeadline(request.getParameter("deadline"));
            dto.setGoal(Integer.parseInt(request.getParameter("goal")));
            dto.setStatus("진행중");

            service.insertTodo(dto);
            response.sendRedirect("todo?action=list");
        } else if ("update".equals(action)) {
            TodoDTO dto = new TodoDTO();
            dto.setTodoId(Integer.parseInt(request.getParameter("todoId")));
            dto.setUserId(request.getParameter("userId"));
            dto.setSubject(request.getParameter("subject"));
            dto.setContent(request.getParameter("content"));
            dto.setDeadline(request.getParameter("deadline"));
            dto.setGoal(Integer.parseInt(request.getParameter("goal")));

            service.updateTodo(dto);
            response.sendRedirect("todo?action=list");
        } else if ("complete".equals(action)) {
            int todoId = Integer.parseInt(request.getParameter("todoId"));
            service.completeTodo(todoId);
            response.sendRedirect("todo?action=list");
        }
    }
}
