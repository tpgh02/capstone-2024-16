package com.dodo.image;

import com.dodo.image.domain.Image;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

@RestController
@RequiredArgsConstructor
public class ImageController {
    private final ImageService imageService;

    @PostMapping("/imageTest")
    public Image uploadImage(
            @RequestParam MultipartFile img
    ) throws IOException {
        return imageService.save(img);
    }

}
