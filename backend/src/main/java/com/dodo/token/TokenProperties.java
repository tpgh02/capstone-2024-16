package com.dodo.token;

import lombok.Getter;
import lombok.Setter;
import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties(prefix = "authentication.access-token")
@Getter @Setter
public class TokenProperties {
    private String secretKey;
}
