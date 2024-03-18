package com.dodo.certification.dto;

import com.dodo.certification.domain.Certification;
import com.dodo.image.domain.Image;
import lombok.Data;

@Data
public class CertificationResponseData {
    public Long certificationId;
    public Image image;

    public CertificationResponseData(Certification certification) {
        this.certificationId = certification.getId();
        this.image = certification.getImage();
    }
}