package com.dodo.sea.domain;

import com.dodo.user.domain.User;
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
    private User user;

    @ManyToOne
    private Creature creature;
}
