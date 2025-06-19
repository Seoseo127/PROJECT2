package service;

import model.dao.PostDAO;
import model.dto.PostDTO;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

public class PostService {
    private PostDAO dao;

    public PostService(Connection conn) {
        this.dao = new PostDAO(conn);
    }

    public int write(PostDTO post) throws SQLException {
        return dao.insert(post);
    }

    public List<PostDTO> list(String category) throws SQLException {
        return dao.selectByCategory(category);
    }

    public PostDTO detail(int postId) throws SQLException {
        return dao.selectById(postId);
    }

    public List<PostDTO> search(String category, String keyword) throws SQLException {
        return dao.search(category, keyword);
    }
}
