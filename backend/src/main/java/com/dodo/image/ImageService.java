package com.dodo.image;

import com.dodo.image.domain.Image;
import com.dodo.image.domain.ImageProperties;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class ImageService {
    private final ImageRepository imageRepository;
    private final ImageProperties imageProperties;

    public Image saveImage(MultipartFile img) throws IOException {
        String uuid = UUID.randomUUID().toString();
        String fullPath = imageProperties.getSavePath() + uuid + ".png";
        Path savePath = Paths.get(fullPath);
        img.transferTo(savePath);
        String url = imageProperties.getServerUrl() + "/img?url=" + uuid;
        return imageRepository.save(new Image(url));
    }

}
