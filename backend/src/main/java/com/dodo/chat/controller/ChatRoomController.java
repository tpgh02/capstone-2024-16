package com.dodo.chat.controller;

import com.dodo.chat.repository.ChatRoomRepository;
import com.dodo.chat.service.ChatRoomService;
import com.dodo.chat.domain.ChatRoom;
import com.dodo.user.UserRepository;
import jakarta.annotation.Nullable;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequiredArgsConstructor
@Slf4j
public class ChatRoomController {

    private final ChatRoomService chatRoomService;

    // 채팅방 생성
    @PostMapping("/chat/create-room")
    public void createRoom(@RequestParam("roomName") String name,
                             @RequestParam("category") String category,
                             @RequestParam("info") String info,
                             @RequestParam(value = "maxUserCnt", defaultValue = "10") String maxUserCnt,
                             @Nullable @RequestParam("roomPwd") String roomPwd){
        ChatRoom room;

        room = chatRoomService.creatChatRoom(name, roomPwd, Integer.parseInt(maxUserCnt), category, info);

        log.info("CREATE Chat Room {}", room);

    }

    // TODO
    /**
     * 채팅방 입장
     * 엔티티를 새로 만들어서 거기에 채팅방id, 유저id를 넣기로 했었나??
    @GetMapping("/chat/enter")
    public String roomEnter(Model model,int roomId){
        log.info("roomId {}", roomId);
    }
    **/
}
