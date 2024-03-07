package com.dodo.room.domain;

import com.dodo.roomuser.domain.RoomUser;
import jakarta.persistence.*;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

@Entity
@NoArgsConstructor
public class Room {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;
    private String password;
    private String info;
    private String notice;
    private LocalDateTime endDay;
    private Long maxUser;
    private Long nowUser;
    private String tag;

    @OneToMany(mappedBy = "room")
    private List<RoomUser> roomUsers;

}
