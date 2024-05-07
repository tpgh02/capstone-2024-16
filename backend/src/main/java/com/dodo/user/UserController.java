package com.dodo.user;

import com.dodo.config.auth.CustomAuthentication;
import com.dodo.image.domain.Image;
import com.dodo.user.domain.UserContext;
import com.dodo.user.dto.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

@RestController
@RequestMapping("api/v1/users/")
@RequiredArgsConstructor
@Slf4j
public class UserController {

    private final UserService userService;

    @PostMapping("register")
    public UserCreateResponseData register(
          @RequestBody  UserCreateRequestData request) {
        return new UserCreateResponseData(userService.register(request));
    }

    @PostMapping("login")
    public UserLoginResponseData login(
            @RequestBody UserLoginRequestData request) {
        return new UserLoginResponseData(userService.login(request));
    }

    @CustomAuthentication
    @GetMapping("me")
    public UserData getMyData(
            @RequestAttribute UserContext userContext
    ) {
        return userService.getMyData(userContext);
    }

    @CustomAuthentication
    @GetMapping("test")
    public String testHandler(
            @RequestAttribute UserContext userContext) {
        log.info("in testHandler : userId = {}", userContext.getUserId());
        return "OK";
    }

    @CustomAuthentication
    @GetMapping("check-password")
    public boolean checkPassword(
            @RequestAttribute UserContext userContext,
            @RequestParam String password
    ) {
        return userService.checkPassword(userContext, password);
    }

    @CustomAuthentication
    @PostMapping("change-password")
    public boolean changePassword(
            @RequestAttribute UserContext userContext,
            @RequestBody PasswordChangeRequestData passwordChangeRequestData
    ) {
        return userService.changePassword(userContext, passwordChangeRequestData);
    }

    @CustomAuthentication
    @PostMapping("user-update")
    public ProfileChangeResponseData changeProfile(
            @RequestAttribute UserContext userContext,
            @RequestParam(required = false) MultipartFile img,
            @RequestParam(required = false) String name,
            @RequestParam(required = false) String introduceMessage
    ) throws IOException {
        return userService.changeProfile(userContext, img, name, introduceMessage);
    }

    @CustomAuthentication
    @GetMapping("simple-profile")
    public ProfileRequestData getProfile(
            @RequestAttribute UserContext userContext
    ) {
        return userService.getProfile(userContext);
    }

    @CustomAuthentication
    @GetMapping("image")
    public Image getImage(
            @RequestAttribute UserContext userContext
    ) {
        return userService.getImage(userContext);
    }
}
