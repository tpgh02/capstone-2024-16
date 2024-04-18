package com.dodo.sea.dto;

import com.dodo.image.domain.Image;
import com.dodo.sea.domain.Creature;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class CreatureData {
    private Long CreatureId;
    private Integer price;
    private String name;
    private String info;
    private Image image;


    public CreatureData(Creature creature) {
        this.CreatureId = creature.getId();
        this.price = creature.getPrice();
        this.name = creature.getName();
        this.info = creature.getInfo();
        this.image = creature.getImage();
    }
}
