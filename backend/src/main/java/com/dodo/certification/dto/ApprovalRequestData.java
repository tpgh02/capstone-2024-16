package com.dodo.certification.dto;

import com.dodo.certification.domain.CertificationStatus;
import lombok.Data;

@Data
public class ApprovalRequestData {
    private Long certificationId;
    private CertificationStatus status;
}
