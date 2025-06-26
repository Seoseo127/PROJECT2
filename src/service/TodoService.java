package service;

import model.dto.TodoDTO;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import util.DBConnection;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class TodoService {
    private final static SqlSessionFactory factory = DBConnection.getFactory();

    public List<TodoDTO> getTodoList(String userId) {
        try (SqlSession session = factory.openSession()) {
            return session.selectList("todoMapper.getTodoList", userId);
        }
    }

    public List<TodoDTO> getCompletedTodoList(String userId) {
        try (SqlSession session = factory.openSession()) {
            return session.selectList("todoMapper.getCompletedTodoList", userId);
        }
    }

    public TodoDTO getTodoById(int todoId) {
        try (SqlSession session = factory.openSession()) {
            return session.selectOne("todoMapper.getTodoById", todoId);
        }
    }

    public boolean insertTodo(TodoDTO dto) {
        try (SqlSession session = factory.openSession(true)) {
            return session.insert("todoMapper.insertTodo", dto) == 1;
        }
    }

    public boolean updateTodo(TodoDTO dto) {
        try (SqlSession session = factory.openSession(true)) {
            return session.update("todoMapper.updateTodo", dto) == 1;
        }
    }

    public boolean completeTodo(int todoId) {
        try (SqlSession session = factory.openSession(true)) {
            return session.update("todoMapper.completeTodo", todoId) == 1;
        }
    }

    public boolean deleteTodo(int todoId) {
        try (SqlSession session = factory.openSession(true)) {
            return session.delete("todoMapper.deleteTodo", todoId) == 1;
        }
    }
}
