package com.dodo.room.dto;

import com.dodo.certification.domain.CertificationStatus;
import com.dodo.image.domain.Image;
import com.dodo.room.domain.*;
import lombok.Data;
import lombok.RequiredArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

@Data
@RequiredArgsConstructor
public class RoomData {
    private Long roomId;
    private String name;
    private Image image;
    private Long maxUser;
    private Long nowUser;
    private LocalDateTime endDay;
    private Periodicity periodicity;
    private String pwd;
    private Category category;
    private String info;
    private Boolean canChat;
    private Integer numOfVoteSuccess;
    private Integer numOfVoteFail;
    private Integer numOfGoal;
    private List<String> goal;
    private Boolean isFull;

    public CertificationStatus status;

    private RoomType roomType;
    private CertificationType certificationType;
    private Integer frequency;

    private List<String> tag;

    public static RoomData of(Room room) {
        RoomData roomData = new RoomData();

        roomData.roomId = room.getId();
        roomData.name = room.getName();
        roomData.maxUser = room.getMaxUser();
        roomData.nowUser = room.getNowUser();
        roomData.endDay = room.getEndDay();
        roomData.periodicity = room.getPeriodicity();
        roomData.pwd = room.getPassword();
        roomData.category = room.getCategory();
        roomData.info = room.getInfo();
        roomData.canChat = room.getCanChat();
        roomData.numOfVoteSuccess = room.getNumOfVoteSuccess();
        roomData.numOfVoteFail = room.getNumOfVoteFail();
        roomData.certificationType = room.getCertificationType();
        roomData.frequency = room.getFrequency();
        roomData.isFull = room.getIsFull();
        roomData.goal = room.getGoal();
        roomData.numOfGoal = room.getNumOfGoal();

        return roomData;
    }

    public void updateTag(List<String> tag){
        this.tag = tag;
    }
}
