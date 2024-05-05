package com.dodo.room.dto;

import com.dodo.certification.domain.Certification;
import com.dodo.certification.domain.CertificationStatus;
import com.dodo.image.domain.Image;
import com.dodo.room.domain.*;
import com.dodo.user.domain.User;
import lombok.Data;
import lombok.RequiredArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

@Data
@RequiredArgsConstructor
public class RoomListData {
    private Long roomId;
    private String name;
    private Image image;
    private Long maxUser;
    private Long nowUser;
    private String password;
    public CertificationStatus status;
    private RoomType roomType;

    public RoomListData(Room room) {
        this.roomId = room.getId();
        this.name = room.getName();
        this.image = room.getImage();
        this.roomType = room.getRoomType();
        this.maxUser = room.getMaxUser();
        this.nowUser = room.getNowUser();
        this.password = room.getPassword();
        this.status = CertificationStatus.WAIT;

    }
    public static RoomListData updateStatus(RoomListData roomListData, CertificationStatus certificationStatus){
        roomListData.status = certificationStatus;

        return roomListData;
    }
}