package com.dodo.room.dto;

import com.dodo.certification.domain.CertificationStatus;
import com.dodo.image.domain.Image;
import com.dodo.room.domain.CertificationType;
import com.dodo.room.domain.Room;
import lombok.Data;
import lombok.RequiredArgsConstructor;

@Data
@RequiredArgsConstructor
public class RoomData {
    public Long roomId;
    public String name;
    public Image image;
    public Long maxUsers;
    public Long nowUsers;
    public CertificationType certificationType;
    public String pwd;
    public String category;
    public String info;
    public String tag;
    public Boolean canChat;

    public CertificationStatus status;

    public RoomData(Room room) {
        this.roomId = room.getId();
        this.name = room.getName();
        // this.image = room.getImage();
        this.maxUsers = room.getMaxUser();
        this.nowUsers = room.getNowUser();
        this.certificationType = room.getCertificationType();

        // TODO
        // 방 불러올 떄 인증 상태를 같이 불러와야 하는디 아직 좀 더 생각해 봐야 할 것 같다.
        // 일단 대기중으로 고정
        this.status = CertificationStatus.WAIT;
        this.maxUsers = room.getMaxUser();
        this.nowUsers = room.getNowUser();

    }
}
