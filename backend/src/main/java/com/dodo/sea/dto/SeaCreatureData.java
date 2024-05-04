package com.dodo.sea.dto;

import com.dodo.image.domain.Image;
import com.dodo.sea.domain.Creature;
import com.dodo.sea.domain.SeaCreature;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
public class SeaCreatureData {
    private Long seaCreatureId;
    private Long coordinate_x;
    private Long coordinate_y;
    private Boolean isActivate;

    private String imageUrl;

    public SeaCreatureData(SeaCreature seaCreature) {
        this.seaCreatureId = seaCreature.getId();
        this.coordinate_x = seaCreature.getCoordinate_x();
        this.coordinate_y = seaCreature.getCoordinate_y();
        this.isActivate = seaCreature.getIsActivate();
        this.imageUrl = seaCreature.getCreature().getImage().getUrl();
    }


}