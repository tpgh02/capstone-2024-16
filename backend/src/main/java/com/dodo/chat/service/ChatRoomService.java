package com.dodo.chat.service;

import com.dodo.chat.domain.Category;
import com.dodo.chat.domain.ChatRoom;
import com.dodo.chat.domain.RoomUser;
import jakarta.persistence.EntityManager;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Service
@Getter
@RequiredArgsConstructor
@Slf4j
public class ChatRoomService {
    EntityManager em;

    // 채팅방 생성
    public ChatRoom creatChatRoom(String roomName, String roomPwd, int maxUserCnt, String category, String info){
        ChatRoom room = ChatRoom.builder()
                .roomName(roomName)
                .roomPwd(roomPwd)
                .maxUserCnt(maxUserCnt)
                .userCount(0)
                .category(category)
                .info(info)
                .build();
        return room;
    }

    // 채팅방 인원 증가
    public void plusUserCnt(int roomId){
        ChatRoom room = em.find(RoomUser.class, roomId).getRoom();
        log.info("cnt : {}", room.getUserCount());
        room.setUserCount(room.getUserCount()+1);
    }
}
