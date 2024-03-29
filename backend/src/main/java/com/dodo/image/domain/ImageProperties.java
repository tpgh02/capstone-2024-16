package com.dodo.image.domain;

import jakarta.annotation.PostConstruct;
import lombok.Getter;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.net.InetAddress;
import java.net.UnknownHostException;

@Getter @Component
@Slf4j
public class ImageProperties {
    // TODO
    // 서버 배포 전에 해당 값들 변경해줘야함
    @Value("${imagepath}")
    private String savePath;

    public  static String serverUrl;

    @PostConstruct
    public void serverUrlSetting() throws UnknownHostException {
        serverUrl = InetAddress
                .getLocalHost()
                .getHostAddress();
        log.info("**** serverUrl = {} ****", serverUrl);
    }


}
