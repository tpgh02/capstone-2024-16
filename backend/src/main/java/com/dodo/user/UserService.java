package com.dodo.user;

import com.dodo.token.TokenService;
import com.dodo.user.domain.AuthenticationType;
import com.dodo.user.domain.PasswordAuthentication;
import com.dodo.user.domain.User;
import com.dodo.user.dto.UserCreateRequestData;
import com.dodo.user.dto.UserLoginRequestData;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@RequiredArgsConstructor
@Service
@Slf4j
public class UserService {

    private final UserRepository userRepository;
    private final PasswordAuthenticationRepository passwordAuthenticationRepository;
    private final PasswordEncoder passwordEncoder;
    private final TokenService tokenService;

    public User register(UserCreateRequestData request) {


        User user = new User(request.getType(), request.getEmail(), 0);
        userRepository.save(user);

        if(request instanceof UserCreateRequestData.PasswordUserCreateRequestData) {
            // 비밀번호 로그인

            var req = (UserCreateRequestData.PasswordUserCreateRequestData)request;
            log.info("password 1 : {}", req.getPassword());
            log.info("encoded password : {}", passwordEncoder.encode(req.getPassword()));
            String password = passwordEncoder.encode(req.getPassword());
            passwordAuthenticationRepository.save(new PasswordAuthentication(user, password));
        } else {
            // 소셜로그인

        }

        return user;
    }

    public String login(UserLoginRequestData request) {
        Long userId = getUserId(request);
        return tokenService.makeToken(userId);
    }


    private Long getUserId(UserLoginRequestData request) {
        if(request.getAuthenticationType() == AuthenticationType.PASSWORD) {
            // 비밀번호 로그인
            UserLoginRequestData.PasswordLoginRequestData req = (UserLoginRequestData.PasswordLoginRequestData)request;
            User user = userRepository.findByEmail(req.getEmail())
                    .orElseThrow(IllegalArgumentException::new);
            PasswordAuthentication passwordAuthentication = passwordAuthenticationRepository.findByUser(user)
                    .orElseThrow(IllegalArgumentException::new);
            log.info("{}", passwordAuthentication.getPassword());
            log.info("{}", passwordEncoder.encode(req.getPassword()));
            if (passwordEncoder.matches(
                    req.getPassword(),
                    passwordAuthentication.getPassword())
            ) {
                return user.getId();
            }
            throw new IllegalArgumentException();
        } else {

        }


        return 0L;
    }
}
