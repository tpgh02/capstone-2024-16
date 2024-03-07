package com.dodo.roomuser.domain;

import com.dodo.room.domain.Room;
import com.dodo.user.domain.User;
import jakarta.persistence.*;

@Entity
public class RoomUser {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    private User user;

    @ManyToOne
    private Room room;

}
