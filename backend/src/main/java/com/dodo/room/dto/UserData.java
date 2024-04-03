package com.dodo.room.dto;

import com.dodo.certification.domain.Certification;
import com.dodo.certification.domain.CertificationStatus;
import com.dodo.image.domain.Image;
import com.dodo.roomuser.domain.RoomUser;
import lombok.Data;

// 피그마 인증방_인증목록 페이지의 데이터
@Data
public class UserData {
    private Long userId;
    private Image image;

    // TODO
    // 인증 상태
    private CertificationStatus status;

    public UserData(RoomUser roomUser) {

    }

}
