package com.dodo.certification;

import com.dodo.certification.dto.CertificationResponseData;
import com.dodo.config.auth.CustomAuthentication;
import com.dodo.user.domain.UserContext;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

@RestController
@RequestMapping("/api/v1/Certification")
@RequiredArgsConstructor
@CustomAuthentication
public class CertificationController {
    private final CertificationService certificationService;

    // 인증 생성, 인증은 아직 X
    @PostMapping("/upload")
    public CertificationResponseData makeCertification(
            @RequestAttribute UserContext userContext,
            @RequestParam Long roomId,
            @RequestParam MultipartFile img
    ) throws IOException {
        return certificationService.makeCertification(userContext, roomId, img);
    }


    // 투표
    @PostMapping("/vote")
    public void voting(
            @RequestAttribute UserContext userContext,
            @RequestParam Long certificationId
    ) {
        certificationService.voting(userContext, certificationId);
    }


    // 방장 승인
    @PostMapping("/")
    public void approval(
            @RequestAttribute UserContext userContext,
            @RequestParam Long certificationId
    ) {
        certificationService.approval(userContext, certificationId);
    }



}
