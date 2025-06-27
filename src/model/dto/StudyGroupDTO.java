package model.dto;

public class StudyGroupDTO {
    private int groupId;
    private String name;
    private String leaderId;
    private String description;
    private int duration;
    private int maxMember;
    private String status; // 모집 중 / 종료됨
    private int currentMemberCount; // ✅ 추가된 필드

    private String leaderNickname;
    
    public int getGroupId() {
        return groupId;
    }

    public void setGroupId(int groupId) {
        this.groupId = groupId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getLeaderId() {
        return leaderId;
    }

    public void setLeaderId(String leaderId) {
        this.leaderId = leaderId;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getDuration() {
        return duration;
    }

    public void setDuration(int duration) {
        this.duration = duration;
    }

    public int getMaxMember() {
        return maxMember;
    }

    public void setMaxMember(int maxMember) {
        this.maxMember = maxMember;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getCurrentMemberCount() {
        return currentMemberCount;
    }

    public void setCurrentMemberCount(int currentMemberCount) {
        this.currentMemberCount = currentMemberCount;
    }
    
    public String getLeaderNickname() {
        return leaderNickname;
    }
    public void setLeaderNickname(String leaderNickname) {
        this.leaderNickname = leaderNickname;
    }
}
