package com.dodo.certification;

import com.dodo.image.ImageRepository;
import com.dodo.image.domain.Image;
import com.dodo.user.domain.UserContext;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.UUID;

@Service
@RequiredArgsConstructor
@Slf4j
public class CertificationService {

    @Value("${imagepath}")
    private String PATH;

    private final CertificationRepository certificationRepository;
    private final ImageRepository imageRepository;

    public void certificate(UserContext userContext, Long roomId, MultipartFile img) throws IOException {
        String uuid = UUID.randomUUID().toString();
        String fullPath = PATH + uuid + ".png";
        Path savePath = Paths.get(fullPath);
        img.transferTo(savePath);
        String url = "http://localhost:8080/img?url=" + uuid;
        log.info("url = {}", url);
        imageRepository.save(new Image(url));
    }

}
