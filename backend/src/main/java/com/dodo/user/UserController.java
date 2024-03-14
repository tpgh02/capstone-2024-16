package com.dodo.user;

import com.dodo.config.auth.CustomAuthentication;
import com.dodo.user.domain.UserContext;
import com.dodo.user.dto.UserCreateRequestData;
import com.dodo.user.dto.UserCreateResponseData;
import com.dodo.user.dto.UserLoginRequestData;
import com.dodo.user.dto.UserLoginResponseData;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("api/v1/users/")
@RequiredArgsConstructor
@Slf4j
public class UserController {

    private final UserService userservice;

    @PostMapping("register")
    public UserCreateResponseData register(
          @RequestBody  UserCreateRequestData request) {
        return new UserCreateResponseData(userservice.register(request));
    }

    @PostMapping("login")
    public UserLoginResponseData login(
            @RequestBody UserLoginRequestData request) {
        return new UserLoginResponseData(userservice.login(request));
    }

    @CustomAuthentication
    @GetMapping("test")
    public String testHandler(
            @RequestAttribute UserContext userContext) {
        log.info("in testHandler : userId = {}", userContext.getUserId());
        return "OK";
    }
}
