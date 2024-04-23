package com.dodo.certification.dto;

import com.dodo.certification.CertificationService;
import com.dodo.image.domain.Image;
import com.dodo.user.domain.User;
import lombok.Data;

@Data
public class CertificationListResponseData {
    private Long userId;
    private Long roomUserId;
    private String userName;
    private Image userImage;
    private Integer max;
    private Integer success;
    private Integer wait;
    private Boolean certification;

    public CertificationListResponseData(CertificationService.CertificationGroup group) {
        User user = group.getRoomUser().getUser();
        this.userId = user.getId();
        this.roomUserId = group.getRoomUser().getId();
        this.userName = user.getName();
        this.userImage = user.getImage();
        this.max = group.getRoomUser().getRoom().getFrequency();
        this.success = group.getSuccess();
        this.wait = group.getWait();

        if(max.equals(success)) {
            this.certification = Boolean.TRUE;
        } else {
            this.certification = Boolean.FALSE;
        }

    }

}
