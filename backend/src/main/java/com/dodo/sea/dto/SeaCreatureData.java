package com.dodo.sea.dto;

import com.dodo.sea.domain.SeaCreature;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class SeaCreatureData {
    private Long seaCreatureId;
    private Long coordinate_x;
    private Long coordinate_y;
    private Boolean is_activate;

    public SeaCreatureData(SeaCreature seaCreature) {
        this.seaCreatureId = seaCreature.getId();
        this.coordinate_x = seaCreature.getCoordinate_x();
        this.coordinate_y = seaCreature.getCoordinate_y();
        this.is_activate = seaCreature.getIs_activate();
    }

}