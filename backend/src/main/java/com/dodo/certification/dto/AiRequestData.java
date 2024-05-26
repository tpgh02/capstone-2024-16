package com.dodo.certification.dto;

import com.dodo.room.domain.Category;
import lombok.Builder;
import lombok.Data;

@Builder
@Data
public class AiRequestData {
    private Long certificationId;
    private Category category;
    private String image;
}
