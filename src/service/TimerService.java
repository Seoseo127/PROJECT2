package service;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import util.DBConnection;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class TimerService {
    private final static SqlSessionFactory factory = DBConnection.getFactory();

    public boolean saveGoalTime(String userId, String subject, int goalMinutes) {
        try (SqlSession session = factory.openSession(true)) {
            Map<String, Object> map = new HashMap<>();
            map.put("userId", userId);
            map.put("subject", subject);
            map.put("goal", goalMinutes);
            return session.insert("timerMapper.saveGoal", map) == 1;
        }
    }

    public int getTotalStudyMinutes(String userId) {
        try (SqlSession session = factory.openSession()) {
            return session.selectOne("timerMapper.getTotalStudyTime", userId);
        }
    }

    public boolean saveAccumulatedTime(String userId, String subject, int minutes) {
        try (SqlSession session = factory.openSession(true)) {
            Map<String, Object> map = new HashMap<>();
            map.put("userId", userId);
            map.put("subject", subject);
            map.put("minutes", minutes);
            return session.update("timerMapper.saveAccumulatedTime", map) == 1;
        }
    }

    public boolean deleteTimerIfCompleted(String userId, String subject) {
        try (SqlSession session = factory.openSession(true)) {
            Map<String, Object> map = new HashMap<>();
            map.put("userId", userId);
            map.put("subject", subject);
            return session.delete("timerMapper.deleteTimer", map) == 1;
        }
    }

    public List<String> getSubjectList(String userId) {
        try (SqlSession session = factory.openSession()) {
            return session.selectList("todoMapper.getSubjectsByUser", userId);
        }
    }

    public Integer getGoalTime(String userId, String subject) {
        try (SqlSession session = factory.openSession()) {
            Map<String, Object> map = new HashMap<>();
            map.put("userId", userId);
            map.put("subject", subject);
            return session.selectOne("timerMapper.getGoalTime", map);
        }
    }

    public Integer getAccumulatedTime(String userId, String subject) {
        try (SqlSession session = factory.openSession()) {
            Map<String, Object> map = new HashMap<>();
            map.put("userId", userId);
            map.put("subject", subject);
            return session.selectOne("timerMapper.getAccumulatedTime", map);
        }
    }
}
