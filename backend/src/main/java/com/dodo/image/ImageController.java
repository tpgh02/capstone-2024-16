package com.dodo.image;

import com.dodo.image.domain.Image;
import lombok.RequiredArgsConstructor;
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
public class ImageController {
    private final ImageService imageService;

    // 사진 불러오기 기능
    @GetMapping("/img")
    public ResponseEntity<byte[]> getImage(@RequestParam String url) {
        File file = new File("https://my-dodo-bucket.s3.ap-northeast-2.amazonaws.com/image/" + url);
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

    @PostMapping("/imageTest")
    public Image uploadImage(
            @RequestParam MultipartFile img
    ) throws IOException {
        return imageService.save(img);
    }

}
