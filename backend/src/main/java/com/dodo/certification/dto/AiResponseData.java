package com.dodo.certification.dto;

import lombok.Data;

import java.util.List;

@Data
public class AiResponseData {
    private String code;
    private String message;
    private Long certificationId;
    private List<String> result;
}
