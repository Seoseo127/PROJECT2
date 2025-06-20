package model.dao;

import java.util.List;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import model.dto.PostDTO;
import util.DBConnection;

public class PostDAO {
    private SqlSessionFactory sqlSessionFactory = DBConnection.getFactory();

    public List<PostDTO> getAllPosts() {
        try (SqlSession session = sqlSessionFactory.openSession()) {
            return session.selectList("PostMapper.selectAllPosts");
        }
    }

    public List<PostDTO> getPostsByCategory(String category) {
        try (SqlSession session = sqlSessionFactory.openSession()) {
            return session.selectList("PostMapper.selectPostsByCategory", category);
        }
    }

    public List<PostDTO> searchPosts(String keyword) {
        try (SqlSession session = sqlSessionFactory.openSession()) {
            return session.selectList("PostMapper.searchPosts", keyword);
        }
    }

    public void insertPost(PostDTO post) {
        try (SqlSession session = sqlSessionFactory.openSession(true)) {
            session.insert("PostMapper.insertPost", post);
        }
    }
}