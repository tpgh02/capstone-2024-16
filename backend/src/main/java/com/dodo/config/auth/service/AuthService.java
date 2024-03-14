package com.dodo.config.auth.service;

import com.dodo.token.TokenService;
import com.dodo.user.PasswordAuthenticationRepository;
import com.dodo.user.UserRepository;
import com.dodo.user.domain.User;
import com.dodo.user.domain.UserContext;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class AuthService {
    private final UserRepository userRepository;
    private final PasswordAuthenticationRepository passwordAuthenticationRepository;
    private final TokenService tokenService;

    public UserContext authenticate(String accessToken) {
        return tokenService.verify(accessToken);
    }
}
