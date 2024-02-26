package com.dodo.service;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;

import com.dodo.domain.UserDomain;
import com.dodo.repository.UserRepository;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class UserService extends DefaultOAuth2UserService {

    @Autowired
    UserRepository userRepository;

    @Override
    public OAuth2User loadUser(OAuth2UserRequest userRequest) throws OAuth2AuthenticationException {

        // email 호출
        Map<String, Object> attributes = super.loadUser(userRequest).getAttributes();
        log.info("ATTR INFO : {}", attributes.toString());

        String email = null;

        OAuth2User user2 = super.loadUser(userRequest);

        email = attributes.get("email").toString();

        // User 존재여부 확인 및 없으면 생성
        if(getUserByEmail(email) == null) {
            log.info("{}({}) NOT EXISTS. REGISTER", email);
            UserDomain user = new UserDomain();
            user.setEmail(email);

            save(user);
        }

        return super.loadUser(userRequest);
    }

    // 저장, 조회만 수행.
    public void save(UserDomain user) {
        userRepository.save(user);
    }

    public UserDomain getUserByEmail(String email) {
        return userRepository.findByEmail(email).orElse(null);
    }
}