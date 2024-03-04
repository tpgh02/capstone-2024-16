package com.dodo;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;

import com.dodo.handelr.OAuthLoginFailureHandler;
import com.dodo.handelr.OAuthLoginSuccessHandler;
import com.dodo.user.service.UserService;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
public class SecurityConfig  {

    @Autowired OAuthLoginSuccessHandler oAuthLoginSuccessHandler;
    @Autowired OAuthLoginFailureHandler oAuthLoginFailureHandler;
    @Autowired UserService userService;


    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {

        http.csrf(AbstractHttpConfigurer::disable)
                .authorizeHttpRequests((authz) -> authz
                // 로그인 페이지는 누구나 접근 가능하게.
                .requestMatchers("/login/**").permitAll()
                .anyRequest().authenticated()
                )
                // oauth 로그인 설정
                .oauth2Login((oauth2) -> oauth2
                        // loginPage가 없으면 Spring Security가 제공하는 기본 OAuth 로그인 페이지가 나옴.
                        .loginPage("/login")
                        .defaultSuccessUrl("http://localhost:3000")
                        .failureUrl("/oauth2/authorization/google")
                        .userInfoEndpoint(userInfoEndpoint -> userInfoEndpoint
                        .userService(userService))
                        // 성공, 실패 핸들러 등록
                        .successHandler(oAuthLoginSuccessHandler)
                        .failureHandler(oAuthLoginFailureHandler));

        return http.build();
    }
}