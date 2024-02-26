package com.dodo.handelr;

import java.io.IOException;
import java.util.Map;

import com.dodo.domain.UserDomain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.oauth2.client.authentication.OAuth2AuthenticationToken;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import com.dodo.service.UserService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class OAuthLoginSuccessHandler extends SimpleUrlAuthenticationSuccessHandler {

    @Autowired UserService userService;

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
                                        Authentication authentication) throws IOException, ServletException {

        // 토큰에서 email 추출
        OAuth2AuthenticationToken token = (OAuth2AuthenticationToken) authentication;

        String email = null;

        // oauth 타입에 따라 데이터가 다르기에 분기
        email = token.getPrincipal().getAttribute("email").toString();


        log.info("LOGIN SUCCESS : {} FROM {}", email);

        UserDomain user = userService.getUserByEmail(email);

        // 세션에 user 저장
        log.info("USER SAVED IN SESSION");
        HttpSession session = request.getSession();
        session.setAttribute("user", user);

        super.onAuthenticationSuccess(request, response, authentication);
    }

}