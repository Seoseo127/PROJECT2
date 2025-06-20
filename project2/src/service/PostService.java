package service;

import java.util.List;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import model.dto.PostDTO;
import util.DBConnection;

public class PostService {
    SqlSessionFactory factory = DBConnection.getFactory();

    public List<PostDTO> getAllPosts() {
        try (SqlSession session = factory.openSession()) {
            return session.selectList("PostMapper.selectAllPosts");
        }
    }

    public void addPost(PostDTO post) {
        try (SqlSession session = factory.openSession()) {
            session.insert("PostMapper.insertPost", post);
            session.commit();
        }
    }
}
