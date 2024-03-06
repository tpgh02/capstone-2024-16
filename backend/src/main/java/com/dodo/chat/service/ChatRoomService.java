package com.dodo.chat.service;

import com.dodo.chat.domain.ChatRoom;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Service
@Getter
@RequiredArgsConstructor
@Slf4j
public class ChatRoomService {

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


}
