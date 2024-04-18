package com.dodo.sea.domain;

import com.dodo.image.domain.Image;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.util.List;

@Entity
@Getter
@NoArgsConstructor
@Builder
@AllArgsConstructor
public class Creature {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;
    private Integer price;
    private String info;

    @ManyToOne
    private Image image;

    @OneToMany(mappedBy = "creature")
    private List<SeaCreature> seaCreatures;
}