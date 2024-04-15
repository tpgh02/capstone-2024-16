package com.dodo.sea.dto;

import lombok.Data;

@Data
public class SeaData {
    private Long seaId;

    public SeaData(Long seaId) {
        this.seaId = seaId;
    }
}
