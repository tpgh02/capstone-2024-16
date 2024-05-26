package com.dodo.sea.dto;

import com.dodo.sea.domain.Creature;
import com.dodo.sea.domain.SeaCreature;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class InventoryCreatureData {
    private Long CreatureId;
    private Integer price;
    private String name;
    private String info;
    private String imageUrl;
    private Boolean isActivate;


    public InventoryCreatureData(Creature creature, SeaCreature seaCreature) {
        this.CreatureId = seaCreature.getId();
        this.price = creature.getPrice();
        this.name = creature.getName();
        this.info = creature.getInfo();
        this.imageUrl = creature.getImage().getUrl();
        this.isActivate = seaCreature.getIsActivate();
    }

    public void updateCreatureId(Long creatureId) {
        this.CreatureId = creatureId;
    }
}
