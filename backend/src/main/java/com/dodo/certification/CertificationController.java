package com.dodo.certification;

import com.dodo.config.auth.CustomAuthentication;
import com.dodo.user.domain.UserContext;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;

@RestController
@RequiredArgsConstructor
public class CertificationController {
    private final CertificationService certificationService;

    // 인증 생성, 인증은 아직 X
    @PostMapping("/api/photo")
    @CustomAuthentication
    public void makeCertification(
            @RequestAttribute UserContext userContext,
            @RequestParam Long roomId,
            @RequestParam MultipartFile img
    ) throws IOException {
        certificationService.makeCertification(userContext, roomId, img);
    }

    /*
    사진 업로드,
    방 사람들 인증 현황 불러오기,
    사진 불러오기,
    인증대기,
    투표,
    방장 승인,
    AI 승인
     */
}
