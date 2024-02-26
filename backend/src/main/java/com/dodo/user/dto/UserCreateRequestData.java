package com.dodo.user.dto;

import com.dodo.user.domain.AuthenticationType;
import com.fasterxml.jackson.annotation.JsonSubTypes;
import com.fasterxml.jackson.annotation.JsonTypeInfo;
import com.fasterxml.jackson.annotation.JsonTypeName;
import lombok.*;

@Data
@JsonTypeInfo(
        use = JsonTypeInfo.Id.NAME,
        property = "type"
)
@JsonSubTypes({
        @JsonSubTypes.Type(value = UserCreateRequestData.PasswordUserCreateRequestData.class, name = "password"),
        @JsonSubTypes.Type(value = UserCreateRequestData.SocialUserCreateRequestData.class, name = "social"),

})
public abstract class UserCreateRequestData {

    @JsonTypeName("social")
    @ToString
    public static class SocialUserCreateRequestData extends UserCreateRequestData {

        // TODO
        //

        String token;
        public SocialUserCreateRequestData(String id, String name, String token) {
            super(AuthenticationType.SOCIAL);
            this.token = token;
        }
    }

    @JsonTypeName("password")
    @ToString
    public static class PasswordUserCreateRequestData extends UserCreateRequestData {

        private final String password1;
        private final String password2;
        private final String username;

        public PasswordUserCreateRequestData(
                String password1,
                String password2,
                String username
        ) {
            super(AuthenticationType.PASSWORD);
            this.password1 = password1;
            this.password2 = password2;
            this.username = username;
        }

        public String getPassword() {
            if(password1.equals(password2)) {
                return password1;
            } else {
                return null;
            }
        }
    }

    private AuthenticationType type;
    private String email;

    public UserCreateRequestData(AuthenticationType type) {
        this.type = type;
    }

}
