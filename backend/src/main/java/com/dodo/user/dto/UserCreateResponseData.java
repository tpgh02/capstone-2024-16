package com.dodo.user.dto;

import com.dodo.user.domain.User;
import lombok.Getter;

@Getter
public class UserCreateResponseData {
    private final Long userId;
    public UserCreateResponseData(User user) {
        this.userId = user.getId();
    }
}
