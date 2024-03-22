package com.dodo.certification.dto;

import com.dodo.certification.domain.Certification;
import com.dodo.image.domain.Image;
import lombok.Data;

@Data
public class CertificationUploadResponseData {
    public Long certificationId;
    public Image image;

    public CertificationUploadResponseData(Certification certification) {
        this.certificationId = certification.getId();
        this.image = certification.getImage();
    }
}