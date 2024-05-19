package com.dodo.statistics.dto;

import com.dodo.certification.domain.Certification;
import com.dodo.image.domain.Image;
import lombok.Data;

import java.time.format.DateTimeFormatter;

@Data
public class AlbumResponseData {
    private Long certificationId;
    private Image image;
    private String date;

    public AlbumResponseData(Certification certification) {
        this.certificationId = certification.getId();
        this.image = certification.getImage();
        this.date = certification.getCreatedTime().format(DateTimeFormatter.ofPattern("yyyy.MM.dd, HH:mm:ss"));
    }
}
