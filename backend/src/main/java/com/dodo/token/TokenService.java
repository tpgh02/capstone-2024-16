package com.dodo.token;

import com.auth0.jwt.JWT;
import com.auth0.jwt.algorithms.Algorithm;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class TokenService {
    private final TokenProperties tokenProperties;

    public String makeToken(Long userId) {
        Algorithm algorithm = Algorithm.HMAC256(tokenProperties.getSecretKey());
        return JWT.create()
                .withClaim("userId", userId)
                .sign(algorithm);
    }
}
