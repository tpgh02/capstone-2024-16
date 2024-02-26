package com.dodo.user;

import com.dodo.user.dto.UserCreateRequestData;
import com.dodo.user.dto.UserCreateResponseData;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

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
}
