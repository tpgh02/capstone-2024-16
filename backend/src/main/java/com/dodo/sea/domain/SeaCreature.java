package com.dodo.sea.domain;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Getter
@NoArgsConstructor
@Builder
@AllArgsConstructor
public class SeaCreature {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private Long coordinate_x;
    private Long coordinate_y;

    @Setter
    private Boolean activate;

    @ManyToOne
    private Sea sea;

    @ManyToOne
    private Creature creature;
}
