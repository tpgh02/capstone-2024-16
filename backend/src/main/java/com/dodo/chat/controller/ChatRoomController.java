package com.dodo.chat.controller;

import com.dodo.chat.service.ChatRoomService;
import com.dodo.config.auth.CustomAuthentication;
import com.dodo.room.RoomRepository;
import com.dodo.room.RoomService;
import com.dodo.room.domain.Room;
import com.dodo.roomuser.RoomUserRepository;
import com.dodo.roomuser.RoomUserService;
import com.dodo.roomuser.domain.RoomUser;
import com.dodo.user.UserRepository;
import com.dodo.user.domain.User;
import com.dodo.user.domain.UserContext;
import jakarta.annotation.Nullable;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequiredArgsConstructor
@RequestMapping("api/v1/chat")
@Slf4j
public class ChatRoomController {

    private final ChatRoomService chatRoomService;
    private final RoomUserService roomUserService;
    private final RoomUserRepository roomUserRepository;
    private final RoomRepository roomRepository;
    private final UserRepository userRepository;
    private final RoomService roomService;

    // 인증방 생성
    @PostMapping("/create-room")
    @ResponseBody
    @CustomAuthentication
    public String createRoom(@RequestParam("roomName") String name,
                             @RequestParam("category") String category,
                             @RequestParam("info") String info,
                             @RequestParam(value = "maxUserCnt", defaultValue = "10") Long maxUserCnt,
                             @Nullable @RequestParam("roomPwd") String roomPwd,
                             @RequestAttribute UserContext userContext){
        Room room = chatRoomService.creatChatRoom(name, roomPwd, maxUserCnt, category, info);
        User user = userRepository.findById(userContext.getUserId()).get();
        RoomUser roomUser = roomUserService.createRoomUser(user, room);
        roomUser.setIsManager(true);
        roomUserRepository.save(roomUser);

        log.info("CREATE Chat Room {}", room);

        return "room id : " + room.getId();
    }

    // 인증방 입장
    @CustomAuthentication
    @GetMapping("/enter/{roomId}")
    public String roomEnter(@PathVariable Long roomId, @RequestAttribute UserContext userContext){
        log.info("roomId {}", roomId);
        log.info("userId {}", userContext.getUserId());

        Room room = roomRepository.findById(roomId).get();
        User user = userRepository.findById(userContext.getUserId()).get();

        RoomUser roomUser = roomUserRepository.findByUserAndRoom(user, room)
                .orElse(null);

        // 유저가 채팅방에 처음 입장
        if (roomUser == null) {
            chatRoomService.plusUserCnt(roomId);
            roomUser = roomUserService.createRoomUser(user, room);
            roomUser = roomUserRepository.findByUserAndRoom(user, room)
                    .orElse(null);
        }

        return "nowUser : " + roomUser.getRoom().getNowUser().toString() + "\n" +
                "room id : " +  roomUser.getRoom().getId();
    }

    // 인증방 나가기
    @CustomAuthentication
    @GetMapping("/room-out/{roomId}")
    public String roomOut(@PathVariable Long roomId, @RequestAttribute UserContext userContext){
        log.info("del roomId : {}", roomId);
        log.info("del userId : {]", userContext.getUserId());

        Room room = roomRepository.findById(roomId).get();
        User user = userRepository.findById(userContext.getUserId()).get();

        chatRoomService.minusUserCnt(roomId);
        roomUserService.deleteChatRoomUser(room, user);

        RoomUser roomUser = roomUserRepository.findByUserAndRoom(user, room)
                .orElse(null);
        if (roomUser == null) {
            return "roomUser = null" + "\n" +
                    "nowUser = " + room.getNowUser();
        }
        else {
            return "roomUser = " + roomUser.getId() ;
        }
    }

    // 인증방 해체하기
    @CustomAuthentication
    @GetMapping("/delete-room/{roomId}")
    public String roomDelete(@PathVariable Long roomId, @RequestAttribute UserContext userContext) {
        log.info("del roomId : {}", roomId);
        log.info("del userId : {}", userContext.getUserId());

        Room room = roomRepository.findById(roomId).get();
        User user = userRepository.findById(userContext.getUserId()).get();
        RoomUser roomUser = roomUserRepository.findByUserAndRoom(user, room).get();

        if (!roomUser.getIsManager()) {
            return "방장이 아닙니다.";
        }
        List<RoomUser> roomUserList = roomUserRepository.findAllByRoomId(roomId).get();

        for (RoomUser ru : roomUserList) {
            roomUserService.deleteChatRoomUser(ru.getRoom(), ru.getUser());
        }

        roomService.deleteRoom(roomId);

        roomUserList = roomUserRepository.findAllByRoomId(roomId)
                .orElse(null);

        if (roomUserList.isEmpty()) {
            return "null";
        }

        return "Error";
    }

}
