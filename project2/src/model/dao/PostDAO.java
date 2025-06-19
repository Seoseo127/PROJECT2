package model.dao;

import java.sql.*;
import java.util.*;

import model.dto.PostDTO;

public class PostDAO {
    private Connection conn;

    public PostDAO(Connection conn) {
        this.conn = conn;
    }

    // 게시글 작성
    public int insert(PostDTO post) throws SQLException {
        String sql = "INSERT INTO POSTS (user_id, category, title, p_content) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, post.getUserId());
            ps.setString(2, post.getCategory());
            ps.setString(3, post.getTitle());
            ps.setString(4, post.getPContent());
            return ps.executeUpdate();
        }
    }

    // 카테고리별 게시글 목록 조회
    public List<PostDTO> selectByCategory(String category) throws SQLException {
        String sql = "SELECT * FROM POSTS WHERE category = ? ORDER BY post_id DESC";
        List<PostDTO> list = new ArrayList<>();
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, category);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                PostDTO post = new PostDTO();
                post.setPostId(rs.getInt("post_id"));
                post.setUserId(rs.getString("user_id"));
                post.setCategory(rs.getString("category"));
                post.setTitle(rs.getString("title"));
                post.setPContent(rs.getString("p_content"));
                list.add(post);
            }
        }
        return list;
    }

    // 게시글 상세 조회
    public PostDTO selectById(int postId) throws SQLException {
        String sql = "SELECT * FROM POSTS WHERE post_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, postId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                PostDTO post = new PostDTO();
                post.setPostId(rs.getInt("post_id"));
                post.setUserId(rs.getString("user_id"));
                post.setCategory(rs.getString("category"));
                post.setTitle(rs.getString("title"));
                post.setPContent(rs.getString("p_content"));
                return post;
            }
        }
        return null;
    }

    // 게시글 검색 (제목 또는 내용)
    public List<PostDTO> search(String category, String keyword) throws SQLException {
        String sql = "SELECT * FROM POSTS WHERE category = ? AND (title LIKE ? OR p_content LIKE ?) ORDER BY post_id DESC";
        List<PostDTO> list = new ArrayList<>();
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, category);
            ps.setString(2, "%" + keyword + "%");
            ps.setString(3, "%" + keyword + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                PostDTO post = new PostDTO();
                post.setPostId(rs.getInt("post_id"));
                post.setUserId(rs.getString("user_id"));
                post.setCategory(rs.getString("category"));
                post.setTitle(rs.getString("title"));
                post.setPContent(rs.getString("p_content"));
                list.add(post);
            }
        }
        return list;
    }
}
