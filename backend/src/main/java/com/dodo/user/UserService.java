package com.dodo.user;

import com.dodo.exception.NotFoundException;
import com.dodo.image.ImageRepository;
import com.dodo.image.domain.Image;
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
    private final ImageRepository imageRepository;

    private final String DEFAULT_IMAGE_URL = "http://localhost:8080/img?url=default";

    @Transactional
    public User register(UserCreateRequestData request) {

        // TODO
        // 기본 이미지 설정
        // 나중에 바꿔야 함
        Image image = imageRepository.findById(1L)
                .orElse(imageRepository.save(new Image(DEFAULT_IMAGE_URL)));


        User user = User.builder()
                .authenticationType(request.getType())
                .email(request.getEmail())
                .mileage(0)
                .image(image)
                .introduceMessage("")
                .build();

        userRepository.save(user);

        if(request instanceof UserCreateRequestData.PasswordUserCreateRequestData) {
            // 비밀번호 로그인

            var req = (UserCreateRequestData.PasswordUserCreateRequestData)request;
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
                    .orElseThrow(NotFoundException::new);
            PasswordAuthentication passwordAuthentication = passwordAuthenticationRepository.findByUser(user)
                    .orElseThrow(NotFoundException::new);
            if (passwordEncoder.matches(
                    req.getPassword(),
                    passwordAuthentication.getPassword())
            ) {
                return user.getId();
            }
            throw new NotFoundException();
        } else {

        }


        return 0L;
    }
}
