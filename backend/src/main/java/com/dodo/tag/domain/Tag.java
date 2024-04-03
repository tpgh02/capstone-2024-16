package com.dodo.tag.domain;

import com.dodo.room.domain.Room;
import jakarta.persistence.*;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.RequiredArgsConstructor;

import java.util.List;

@Entity
@Getter
@NoArgsConstructor
@RequiredArgsConstructor
public class Tag {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;

    @OneToMany
    private List<RoomTag> roomTags;

    @Builder
    public Tag(String name) {
        this.name = name;}
}
