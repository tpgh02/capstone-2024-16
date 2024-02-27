package com.dodo.user.dto;

import lombok.Getter;

@Getter
public class UserLoginResponseData {
    String token;

    public UserLoginResponseData(String token) {
        this.token = token;
    }
}
