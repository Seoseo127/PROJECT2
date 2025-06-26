package model.dao;

import model.dto.PostDTO;
import org.apache.ibatis.session.SqlSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class PostDAO {
    private final SqlSession sqlSession;

    public PostDAO(SqlSession sqlSession) {
        this.sqlSession = sqlSession;
    }

    public List<PostDTO> selectPosts(String category, String search) {
        Map<String, Object> params = new HashMap<>();
        params.put("category", category);
        params.put("search", search);
        return sqlSession.selectList("util.mapper.PostMapper.selectPosts", params);
    }

    public PostDTO selectPostById(int postId) {
        return sqlSession.selectOne("util.mapper.PostMapper.selectPostById", postId);
    }

    public int insertPost(PostDTO post) {
        int result = sqlSession.insert("util.mapper.PostMapper.insertPost", post);
        sqlSession.commit();
        return result;
    }

    public int updatePost(PostDTO post) {
        int result = sqlSession.update("util.mapper.PostMapper.updatePost", post);
        sqlSession.commit();
        return result;
    }

    public int deletePost(int postId, String userId) {
        Map<String, Object> params = new HashMap<>();
        params.put("postId", postId);
        params.put("userId", userId);
        int result = sqlSession.delete("util.mapper.PostMapper.deletePost", params);
        sqlSession.commit();
        return result;
    }
}
