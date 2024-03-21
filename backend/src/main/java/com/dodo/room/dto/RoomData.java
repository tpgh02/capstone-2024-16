package com.dodo.room.dto;

import com.dodo.certification.domain.CertificationStatus;
import com.dodo.room.domain.Room;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.RequiredArgsConstructor;

@Data
@RequiredArgsConstructor
public class RoomData {
    public Long roomId;
    public String name;
    public Long maxUsers;
    public Long nowUsers;
    public String pwd;
    public String category;
    public String info;

    public CertificationStatus status;

    public RoomData(Room room) {
        this.roomId = room.getId();
        this.name = room.getName();
        this.maxUsers = room.getMaxUser();
        this.nowUsers = room.getNowUser();

    }
}