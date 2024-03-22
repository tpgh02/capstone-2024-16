package com.dodo.certification;

import com.dodo.certification.dto.CertificationListResponseData;
import com.dodo.certification.dto.CertificationUploadResponseData;
import com.dodo.config.auth.CustomAuthentication;
import com.dodo.user.domain.UserContext;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;

@RestController
@RequestMapping("/api/v1/certification")
@RequiredArgsConstructor
@CustomAuthentication
public class CertificationController {
    private final CertificationService certificationService;

    // 인증 생성, 인증은 아직 X
    @PostMapping("/upload")
    public CertificationUploadResponseData makeCertification(
            @RequestAttribute UserContext userContext,
            @RequestParam Long roomId,
            @RequestParam MultipartFile img
    ) throws IOException {
        return certificationService.makeCertification(userContext, roomId, img);
    }


    // 인증방의 인증들 리스트 불러오기
    @GetMapping("/list/{roomId}")
    public List<CertificationListResponseData> getList(
            @RequestAttribute UserContext userContext,
            @PathVariable Long roomId
    ) {
        return certificationService.getList(userContext, roomId);
    }

    // 특정 인증 클릭했을 때 나오는 디테일 화면 보여주기
    @GetMapping("/detail/{certificationId}")
    public void getCertificationDetail(
            @RequestAttribute UserContext userContext,
            @PathVariable String certificationId
    ) {

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
