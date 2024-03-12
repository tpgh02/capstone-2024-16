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

    @Value("${imagepath}")
    private String PATH;

    private final CertificationService certificationService;

    @PostMapping("/api/photo")
    @CustomAuthentication
    public void certificateImage(
            @RequestAttribute UserContext userContext,
            @RequestParam Long roomId,
            @RequestParam MultipartFile img
    ) throws IOException {
        certificationService.certificate(userContext, roomId, img);
    }


    @GetMapping("/img")
    public ResponseEntity<byte[]> getImage(@RequestParam String url) {
        File file = new File(PATH + url + ".png");
        ResponseEntity<byte[]> result = null;
        try {
            HttpHeaders headers = new HttpHeaders();
            headers.add("Content-Type", Files.probeContentType(file.toPath()));
            result = new ResponseEntity<>(FileCopyUtils.copyToByteArray(file),headers, HttpStatus.OK);
        } catch (IOException e) {
            e.printStackTrace();
        }
        return result;
    }
}
