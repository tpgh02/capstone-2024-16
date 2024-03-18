package com.dodo.roomuser.domain;

import com.dodo.certification.domain.Certification;
import com.dodo.room.domain.Room;
import com.dodo.user.domain.User;
import jakarta.persistence.*;
import lombok.Getter;

import java.util.List;

@Entity
@Getter
public class RoomUser {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    private User user;

    @ManyToOne
    private Room room;

    @Enumerated(EnumType.STRING)
    private RoomRole roomRole;

    @OneToMany(mappedBy = "roomUser")
    private List<Certification> certification;

    public RoomUser(User user, Room room) {
        this.room = room;
        this.user = user;
    }
}
