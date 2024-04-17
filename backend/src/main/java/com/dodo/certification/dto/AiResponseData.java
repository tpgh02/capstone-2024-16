package com.dodo.certification.dto;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

import java.util.List;
import java.util.Optional;

@Data
public class AiResponseData {
    private String code;
    private String message;
    private Long certificationId;
    private Optional<List<String>> result;

    @JsonCreator
    public AiResponseData(
            @JsonProperty("code") String code,
            @JsonProperty("message") String message,
            @JsonProperty("certification_id") Long certificationId,
            @JsonProperty("result") Optional<List<String>> result
    ) {
        this.code = code;
        this.message = message;
        this.certificationId = certificationId;
        this.result = result;
    }
}
