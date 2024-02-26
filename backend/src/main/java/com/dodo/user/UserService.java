package com.dodo.user;

import com.dodo.user.domain.PasswordAuthentication;
import com.dodo.user.domain.User;
import com.dodo.user.dto.UserCreateRequestData;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@RequiredArgsConstructor
@Service
public class UserService {

    private final UserRepository userRepository;
    private final PasswordAuthenticationRepository passwordAuthenticationRepository;

    @Transactional
    public User register(UserCreateRequestData request) {

        if(request instanceof UserCreateRequestData.PasswordUserCreateRequestData) {
            // 비밀번호 로그인
            var req = (UserCreateRequestData.PasswordUserCreateRequestData)request;
            passwordAuthenticationRepository.save(new PasswordAuthentication(req.getPassword()));
        } else {
            // 소셜로그인
        }

        User user = new User(request.getType(), request.getEmail(), 0);
        return userRepository.save(user);
    }
}
