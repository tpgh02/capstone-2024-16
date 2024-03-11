package com.dodo.chat.domain;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
import java.util.List;


@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
@Table(name = "room")
public class ChatRoom {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int roomId;

    // TODO
    // AI 채팅방 or 일반 채팅방
    /**
    public enum roomType{
        AI, NORMAL;
    }
    private roomType type;
     **/

    // TODO
        /**
    public enum voteType{
        MEMBERVOTE,
        MANAGER
    }
         **/

    private String roomName;
    private String pwd;
    private LocalDateTime endDate;
    private int userCount;
    private int maxUserCnt;
    private String roomPwd;
    private String category;
    private String info;
    private String notice;

//    @ManyToOne
//    private Category category;

    @OneToMany(mappedBy = "room")
    private List<RoomUser> roomUsers;

}
