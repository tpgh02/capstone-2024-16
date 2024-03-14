package com.dodo.token;

import com.auth0.jwt.JWT;
import com.auth0.jwt.algorithms.Algorithm;
import com.auth0.jwt.interfaces.DecodedJWT;
import com.dodo.user.domain.UserContext;
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
                // withClaim("roomId", roomId)
                .sign(algorithm);
    }

    public UserContext verify(String token) {
        Algorithm algorithm = Algorithm.HMAC256(tokenProperties.getSecretKey());
        DecodedJWT decodedToken = JWT.require(algorithm).build().verify(token);
        long userId = decodedToken.getClaim("userId").asLong();
//        long roomId = decodedToken.getClaim("roomId").asLong();
        return new UserContext(userId);
    }
}
