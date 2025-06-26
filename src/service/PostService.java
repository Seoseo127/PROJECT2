// PostService.java - 중복 제거 및 리팩토링 완료
package service;

import model.dto.PostDTO;
import org.apache.ibatis.session.*;
import util.DBConnection;

import java.util.*;

public class PostService {
    private final static SqlSessionFactory factory = DBConnection.getFactory();

    
    public List<PostDTO> getTopPosts() {
        SqlSession session = factory.openSession();
        try {
            return session.selectList("postMapper.getTopPosts");
        } finally {
            session.close();
        }
    }
    
    
    public List<PostDTO> getTopPostsByCategory(String category) {
        SqlSession session = factory.openSession();
        try {
            return session.selectList("postMapper.getTopPostsByCategory", category);
        } finally {
            session.close();
        }
    }


    public List<PostDTO> getAllPosts(String category, String keyword) {
        try (SqlSession session = factory.openSession()) {
            Map<String, Object> params = new HashMap<>();
            params.put("category", category);
            params.put("keyword", keyword);
            return session.selectList("communityMapper.getAllPosts", params);
        }
    }

    public PostDTO getPostById(int postId) {
        try (SqlSession session = factory.openSession()) {
            return session.selectOne("communityMapper.getPostById", postId);
        }
    }

    public void insertPost(PostDTO post) {
        try (SqlSession session = factory.openSession()) {
            session.insert("communityMapper.insertPost", post);
            session.commit();
        }
    }

    public boolean createPost(PostDTO dto) {
        try (SqlSession session = factory.openSession(true)) {
            return session.insert("communityMapper.insertPost", dto) == 1;
        }
    }

    public void updatePost(PostDTO post) {
        try (SqlSession session = factory.openSession()) {
            session.update("communityMapper.updatePost", post);
            session.commit();
        }
    }

    public void deletePost(int postId) {
        try (SqlSession session = factory.openSession()) {
            session.delete("communityMapper.deletePost", postId);
            session.commit();
        }
    }

    public static List<PostDTO> getMyPosts(String userId) {
        try (SqlSession session = factory.openSession()) {
            return session.selectList("communityMapper.selectMyPosts", userId);
        }
    }

    public void deletePostWithComments(int postId) {
        try (SqlSession session = factory.openSession()) {
            session.delete("communityMapper.deletePostById", postId);
            session.commit();
        }
    }

    public int getTotalPostCount(String category, String keyword) {
        try (SqlSession session = factory.openSession()) {
            Map<String, Object> params = new HashMap<>();
            params.put("category", category);
            params.put("keyword", keyword);
            return session.selectOne("communityMapper.getTotalPostCount", params);
        }
    }

    public List<PostDTO> getPostsWithPaging(String category, String keyword, int offset, int limit) {
        try (SqlSession session = factory.openSession()) {
            Map<String, Object> params = new HashMap<>();
            params.put("category", category);
            params.put("keyword", keyword);
            params.put("offset", offset);
            params.put("limit", limit);
            return session.selectList("communityMapper.getPostsWithPaging", params);
        }
    }

    public List<PostDTO> getMyPostsPaging(Map<String, Object> map) {
        try (SqlSession session = factory.openSession()) {
            return session.selectList("communityMapper.selectMyPostsPaging", map);
        }
    }

    public int getMyPostCount(String userId) {
        try (SqlSession session = factory.openSession()) {
            return session.selectOne("communityMapper.getMyPostCount", userId);
        }
    }

    public void increaseViewCount(int postId) {
        try (SqlSession session = factory.openSession()) {
            session.update("postMapper.increaseViewCount", postId);
            session.commit();
        }
    }

    public boolean likePost(int postId, String userId) {
        try (SqlSession session = factory.openSession()) {
            Map<String, Object> param = new HashMap<>();
            param.put("postId", postId);
            param.put("userId", userId);

            int alreadyLiked = session.selectOne("postMapper.hasLiked", param);
            if (alreadyLiked == 0) {
                session.insert("postMapper.addLike", param);
                session.update("postMapper.increaseLikeCount", postId);
                session.commit();
                return true;
            }
            return false;
        }
    }

    public int getLikeCount(int postId) {
        try (SqlSession session = factory.openSession()) {
            Integer result = session.selectOne("postMapper.getLikeCount", postId);
            return (result != null) ? result : 0;
        }
    }

    public int hasLiked(Map<String, Object> param) {
        try (SqlSession session = factory.openSession()) {
            return session.selectOne("postMapper.hasLiked", param);
        }
    }
    
    
    // 좋아요 취소
    public boolean unlikePost(int postId, String userId) {
        try (SqlSession session = factory.openSession()) {
            Map<String, Object> param = new HashMap<>();
            param.put("postId", postId);
            param.put("userId", userId);

            int alreadyLiked = session.selectOne("postMapper.hasLiked", param);
            if (alreadyLiked > 0) {
                session.delete("postMapper.removeLike", param);
                session.update("postMapper.decreaseLikeCount", postId);
                session.commit();
                return true;
            }
            return false;
        }
    }

}
