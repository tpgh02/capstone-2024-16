package com.dodo.user.dto;

import com.dodo.user.domain.AuthenticationType;
import com.fasterxml.jackson.annotation.JsonSubTypes;
import com.fasterxml.jackson.annotation.JsonTypeInfo;
import com.fasterxml.jackson.annotation.JsonTypeName;
import lombok.*;

@Getter
@NoArgsConstructor
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
    @Getter
    @NoArgsConstructor
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
    @Getter
    @NoArgsConstructor
    public static class PasswordUserCreateRequestData extends UserCreateRequestData {
        private String password1;
        private String password2;
        private String username;

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
