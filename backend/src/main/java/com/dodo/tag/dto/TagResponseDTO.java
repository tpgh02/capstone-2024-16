package com.dodo.tag.dto;

import lombok.Data;
import lombok.Getter;

import java.util.List;

@Data
@Getter
public class TagResponseDTO {

    private final List<String> tagNames;

    public TagResponseDTO(List<String> tagNames){this.tagNames = tagNames;}
}
