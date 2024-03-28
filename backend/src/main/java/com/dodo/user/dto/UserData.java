package com.dodo.user.dto;

import com.dodo.image.domain.Image;
import com.dodo.user.domain.AuthenticationType;
import com.dodo.user.domain.User;
import lombok.Data;

@Data
public class UserData {
    private Long userId;
    private AuthenticationType authenticationType;
    private String email;
    private String name;
    private Integer mileage;
    private String introduceMessage;
    private Image image;

    public UserData(User user) {
        this.userId = user.getId();
        this.authenticationType = user.getAuthenticationType();
        this.email = user.getEmail();
        this.name = user.getName();
        this.mileage = user.getMileage();
        this.introduceMessage = user.getIntroduceMessage();
        this.image = user.getImage();
    }
}
