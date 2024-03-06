package com.dodo.chat.domain;

import jakarta.persistence.*;
import lombok.*;


@Getter
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

    private String roomName;
    private int userCount;
    private int maxUserCnt;
    private String roomPwd;
    private String category;
    private String info;

}
