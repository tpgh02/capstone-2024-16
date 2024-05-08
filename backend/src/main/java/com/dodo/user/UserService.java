package com.dodo.user;

import com.dodo.exception.NotFoundException;
import com.dodo.image.ImageRepository;
import com.dodo.image.ImageService;
import com.dodo.image.domain.Image;
import com.dodo.token.TokenService;
import com.dodo.user.domain.AuthenticationType;
import com.dodo.user.domain.PasswordAuthentication;
import com.dodo.user.domain.User;
import com.dodo.user.domain.UserContext;
import com.dodo.user.dto.*;
import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

@RequiredArgsConstructor
@Service
@Slf4j
public class UserService {

    private final UserRepository userRepository;
    private final PasswordAuthenticationRepository passwordAuthenticationRepository;
    private final PasswordEncoder passwordEncoder;
    private final TokenService tokenService;
    private final ImageRepository imageRepository;
    private final ImageService imageService;


    @Transactional
    public User register(UserCreateRequestData request) {
        if(userRepository.existsByEmail(request.getEmail())) {
            throw new RuntimeException("이메일이 이미 존재합니다");
        }

        // TODO
        // 기본 이미지 설정
        // 나중에 바꿔야 함
        Image image = imageRepository.findById(1L).get();


        log.info("{}", request.getType());
        User user = User.builder()
                .authenticationType(request.getType())
                .email(request.getEmail())
                .name(request.getEmail().split("@")[0])
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
        log.info("{}", request.getAuthenticationType());
        Long userId = getUserId(request);
        return tokenService.makeToken(userId);
    }


    private Long getUserId(UserLoginRequestData request) {
        if(request.getAuthenticationType() == AuthenticationType.PASSWORD) {
            // 비밀번호 로그인
            UserLoginRequestData.PasswordLoginRequestData req = (UserLoginRequestData.PasswordLoginRequestData)request;
            User user = userRepository.findByEmail(req.getEmail())
                    .orElseThrow(() -> new NotFoundException("유저를 찾을 수 없습니다"));
            PasswordAuthentication passwordAuthentication = passwordAuthenticationRepository.findByUser(user)
                    .orElseThrow(() -> new NotFoundException("비밀번호 인증 정보를 찾을 수 없습니다"));
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

    public UserData getMyData(UserContext userContext) {
        User user = userRepository.findById(userContext.getUserId())
                .orElseThrow(() -> new NotFoundException("유저를 찾을 수 없습니다"));

        return new UserData(user);
    }

    public void update(UserContext userContext, UserData userData) {
        User user = userRepository.findById(userContext.getUserId())
                .orElseThrow(() -> new NotFoundException("유저를 찾을 수 없습니다"));

        user.update(userData.getName(), userData.getImage(), userData.getIntroduceMessage());
        userRepository.save(user);
    }

    @PostConstruct
    public void makeInitialData() {
        Image image = imageRepository.findById(1L).get();
        User user = User.builder()
                .authenticationType(AuthenticationType.PASSWORD)
                .email("hello@hello.com")
                .name("hello")
                .mileage(999999999)
                .image(image)
                .introduceMessage("")
                .build();

        userRepository.save(user);
        String password = passwordEncoder.encode("123");

        passwordAuthenticationRepository.save(new PasswordAuthentication(user, password));
    }

    public boolean checkPassword(UserContext userContext, String password) {
        User user = getUser(userContext);
        PasswordAuthentication passwordAuthentication = passwordAuthenticationRepository.findByUser(user).get();
        if(!passwordEncoder.matches(password, passwordAuthentication.getPassword())) {
            throw new RuntimeException("비밀번호가 일치하지 않습니다.");
        }
        return true;
    }

    @Transactional
    public boolean changePassword(UserContext userContext, PasswordChangeRequestData passwordChangeRequestData) {
        User user = getUser(userContext);
        PasswordAuthentication passwordAuthentication = passwordAuthenticationRepository.findByUser(user).get();
        if(!passwordEncoder.matches(passwordChangeRequestData.getCurrentPassword(), passwordAuthentication.getPassword())) {
            throw new RuntimeException("나의 비밀번호가 일치하지 않습니다.");
        }
        if(!passwordChangeRequestData.getChangePassword1().equals(passwordChangeRequestData.getChangePassword2())) {
            throw new RuntimeException("새로운 비밀번호 1, 2가 일치하지 않습니다.");
        }
        if(passwordChangeRequestData.getCurrentPassword().equals(passwordChangeRequestData.getChangePassword1())) {
            throw new RuntimeException("현재 비밀번호와 새로운 비밀번호가 일치합니다.");
        }
        passwordAuthentication.setPassword(passwordEncoder.encode(passwordChangeRequestData.getChangePassword1()));
        return true;
    }


    @Transactional
    public ProfileChangeResponseData changeProfile(UserContext userContext, MultipartFile img, UserUpdateRequestData requestData) throws IOException {
        User user = getUser(userContext);
        if(img != null) {
            Image image = imageService.save(img);
            user.setImage(image);
        }
        if(requestData != null) {
            if(requestData.getName() != null) user.setName(requestData.getName());
            if(requestData.getIntroduceMessage() != null) user.setIntroduceMessage(requestData.getIntroduceMessage());
        }
        return new ProfileChangeResponseData(user);
    }

    public ProfileRequestData getProfile(UserContext userContext) {
        User user = getUser(userContext);
        return new ProfileRequestData(user);
    }

    public Image getImage(UserContext userContext) {
        User user = getUser(userContext);
        return user.getImage();
    }

    @Transactional
    public User getUser(UserContext userContext) {
        return userRepository.findById(userContext.getUserId())
                .orElseThrow(() -> new NotFoundException("유저정보가 올바르지 않습니다."));
    }
}
