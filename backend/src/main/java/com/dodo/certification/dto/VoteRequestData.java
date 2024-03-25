package com.dodo.certification.dto;

import com.dodo.certification.domain.VoteStatus;
import lombok.Data;

@Data
public class VoteRequestData {
    private Long certificationId;
    private VoteStatus voteStatus;
}
