package com.dodo.user.domain;

import lombok.Data;

@Data
public class PasswordChangeRequestData {
    public String currentPassword;
    public String changePassword1;
    public String changePassword2;
}
