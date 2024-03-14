package com.dodo.chat.controller;

import com.dodo.chat.service.ChatRoomService;
import com.dodo.room.domain.Room;
import jakarta.annotation.Nullable;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequiredArgsConstructor
@RequestMapping("api/v1/chat")
@Slf4j
public class ChatRoomController {

    private final ChatRoomService chatRoomService;

    // 채팅방 생성
    @PostMapping("/create-room")
    @ResponseBody
    public String createRoom(@RequestParam("roomName") String name,
                             @RequestParam("category") String category,
                             @RequestParam("info") String info,
                             @RequestParam(value = "maxUserCnt", defaultValue = "10") String maxUserCnt,
                             @Nullable @RequestParam("roomPwd") String roomPwd){
        Room room;

        room = chatRoomService.creatChatRoom(name, roomPwd, Long.parseLong(maxUserCnt), category, info);

        log.info("CREATE Chat Room {}", room);

        return "room id : " + room.getId();
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
