package com.dodo.statistics.dto;

import com.dodo.image.domain.Image;
import lombok.Data;

@Data
public class AlbumResponseData {
    private Long certificationId;
    private Image image;
    private String Date;
}
