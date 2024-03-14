package com.dodo.image.domain;

import lombok.Getter;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Getter @Component
public class ImageProperties {
    @Value("${imagepath}")
    private String savePath;

    @Value("${serverurl")
    private String serverUrl;
}
