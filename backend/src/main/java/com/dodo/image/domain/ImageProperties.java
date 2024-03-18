package com.dodo.image.domain;

import lombok.Getter;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Getter @Component
public class ImageProperties {
    // TODO
    // 서버 배포 전에 해당 값들 변경해줘야함
    @Value("${imagepath}")
    private String savePath;

    @Value("${serverurl}")
    private String serverUrl;
}
