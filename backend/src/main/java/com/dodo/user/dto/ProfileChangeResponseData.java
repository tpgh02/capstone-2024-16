package com.dodo.user.dto;

import com.dodo.image.domain.Image;
import com.dodo.user.domain.User;
import lombok.Data;

@Data
public class ProfileChangeResponseData {
    private Image image;
    private String name;
    private String introduceMessage;

    public ProfileChangeResponseData(User user) {
        this.image = user.getImage();
        this.name = user.getName();
        this.introduceMessage = user.getIntroduceMessage();
    }
}
