package com.dodo.certification.dto;

import com.dodo.image.domain.Image;
import lombok.Data;

@Data
public class CertificationResponseData {
    public Long certificationId;
    public Image image;
}
