package com.dodo.user.dto;

import com.dodo.user.domain.AuthenticationType;
import com.fasterxml.jackson.annotation.JsonSubTypes;
import com.fasterxml.jackson.annotation.JsonTypeInfo;
import com.fasterxml.jackson.annotation.JsonTypeName;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@JsonTypeInfo(
        use = JsonTypeInfo.Id.NAME,
        property = "type"
)
@JsonSubTypes({
        @JsonSubTypes.Type(value = UserLoginRequestData.PasswordLoginRequestData.class, name = "password")
//        @JsonSubTypes.Type(value =..class, name = "social"),
})
public abstract class UserLoginRequestData {
    private AuthenticationType authenticationType;

    @JsonTypeName("password")
    @Getter
    public static class PasswordLoginRequestData extends UserLoginRequestData {
        private String email;
        private String password;
        public PasswordLoginRequestData() {
            super(AuthenticationType.PASSWORD);
        }
    }

    public UserLoginRequestData(AuthenticationType authenticationType) {
        this.authenticationType = authenticationType;
    }
}
