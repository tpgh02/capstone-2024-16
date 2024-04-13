package com.dodo.room.dto;

import com.dodo.certification.domain.CertificationStatus;
import com.dodo.image.domain.Image;
import com.dodo.room.domain.Category;
import com.dodo.room.domain.CertificationType;
import com.dodo.room.domain.Periodicity;
import com.dodo.room.domain.Room;
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
    private Long nowUsers;
    private LocalDateTime endDay;
    private Periodicity periodicity;
    private String pwd;
    private Category category;
    private String info;
    private Boolean canChat;
    private Integer numOfVoteSuccess;
    private Integer numOfVoteFail;

    public CertificationStatus status;

    private CertificationType certificationType;
    private Integer frequency;

    private List<String> tag;

    public RoomData(Room room) {
        this.roomId = room.getId();
        this.name = room.getName();
        // this.image = room.getImage();
        this.maxUser = room.getMaxUser();
        this.nowUsers = room.getNowUser();
        this.certificationType = room.getCertificationType();

        // TODO
        // 방 불러올 떄 인증 상태를 같이 불러와야 하는디 아직 좀 더 생각해 봐야 할 것 같다.
        // 일단 대기중으로 고정
        this.status = CertificationStatus.WAIT;
        this.maxUser = room.getMaxUser();
        this.nowUsers = room.getNowUser();

    }

    public static RoomData of(Room room) {
        RoomData roomData = new RoomData();

        roomData.roomId = room.getId();
        roomData.name = room.getName();
        roomData.maxUser = room.getMaxUser();
        roomData.nowUsers = room.getNowUser();
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

        return roomData;
    }
}
