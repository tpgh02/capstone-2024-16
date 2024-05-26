package com.dodo.certification.dto;

import com.dodo.room.domain.Category;
import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

import java.util.List;
import java.util.Optional;

@Data
public class AiResponseData {
    private Integer code;
    private String message;
    private Category category;
    private Long certificationId;
    private Optional<List<String>> result;

    @JsonCreator
    public AiResponseData(
            @JsonProperty("code") Integer code,
            @JsonProperty("message") String message,
            @JsonProperty("category") Category category,
            @JsonProperty("certification_id") Long certificationId,
            @JsonProperty("result") Optional<List<String>> result
    ) {
        this.code = code;
        this.message = message;
        this.category = category;
        this.certificationId = certificationId;
        this.result = result;
    }
}
