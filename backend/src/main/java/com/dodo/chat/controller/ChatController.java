package com.dodo.chat.controller;

import com.dodo.chat.domain.Message;
import com.dodo.chat.service.ChatRoomService;
import com.dodo.user.User;
import com.dodo.user.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessageHeaderAccessor;
import org.springframework.messaging.simp.SimpMessageSendingOperations;
import org.springframework.stereotype.Controller;

@Slf4j
@RequiredArgsConstructor
@Controller
public class ChatController {

    private final SimpMessageSendingOperations template;

    private final ChatRoomService chatRoomService;
    private final UserRepository user;


    // 채팅방 입장
    @MessageMapping("/chat/enterUser")
    public void enterUser(@Payload Message chat, SimpMessageHeaderAccessor headerAccessor) {

        // TODO
        // 채팅방에 유저 추가


        int userID = chat.getUserId();

        // 반환 결과를 socket session 에 userID 로 저장
        headerAccessor.getSessionAttributes().put("userID", userID);
        headerAccessor.getSessionAttributes().put("roomId", chat.getRoomId());

        User sender = user.findByUserId(userID);
        chat.setMessage(sender.getName() + " 님 입장");
        template.convertAndSend("/sub/chat/room/" + chat.getRoomId(), chat);

    }

    // 메세지 전송
    @MessageMapping("/chat/sendMessage")
    public void sendMessage(@Payload Message chat) {
        log.info("CHAT {}", chat);
        chat.setMessage(chat.getMessage());
        template.convertAndSend("/sub/chat/room/" + chat.getRoomId(), chat);

    }
}
