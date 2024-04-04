package com.dodo.tag.domain;

import com.dodo.room.domain.Room;
import jakarta.persistence.*;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@Getter
@NoArgsConstructor
public class RoomTag {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    private Room room;

    @ManyToOne
    private Tag tag;

    @Builder
    public RoomTag(Room room, Tag tag) {
        this.room = room;
        this.tag = tag;
    }
}
