package com.dodo.room;

import com.dodo.config.auth.CustomAuthentication;
import com.dodo.room.dto.RoomData;
import com.dodo.room.dto.UserData;
import com.dodo.user.domain.UserContext;
import lombok.RequiredArgsConstructor;
import com.dodo.room.domain.Room;
import com.dodo.room.dto.RoomData;
import com.dodo.roomuser.RoomUserRepository;
import com.dodo.roomuser.RoomUserService;
import com.dodo.roomuser.domain.RoomUser;
import com.dodo.user.UserRepository;
import com.dodo.user.domain.User;
import com.dodo.user.domain.UserContext;
import lombok.*;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/room")
@RequiredArgsConstructor
@CustomAuthentication
@Slf4j
public class RoomController {

    private final RoomService roomService;
    private final RoomUserService roomUserService;
    private final RoomUserRepository roomUserRepository;
    private final RoomRepository roomRepository;
    private final UserRepository userRepository;

    @GetMapping("/list")
    public List<RoomData> getMyRoomList(
            @RequestAttribute UserContext userContext
    ) {
        return roomService.getMyRoomList(userContext);
    }


    // TODO
    // UserData 라는 이름으로 괜찮을지,,
    @GetMapping("/users")
    public List<UserData> getUsersInTheRoom(
            @RequestAttribute UserContext userContext,
            @RequestParam Long roomId) {
        return roomService.getUsers(userContext, roomId);
    }

    // 인증방 생성
    @PostMapping("/create-room")
    @ResponseBody
    @CustomAuthentication
    public RoomData createRoom(@RequestBody RoomData roomData, @RequestAttribute UserContext userContext){
        Room room = roomService.creatChatRoom(roomData.getName(), roomData.getPwd(), roomData.getMaxUsers(), roomData.getCategory(), roomData.getInfo(), roomData.getTag(), roomData.getCertificationType(), roomData.getCanChat());
        User user = userRepository.findById(userContext.getUserId()).get();
        RoomUser roomUser = roomUserService.createRoomUser(user, room);
        roomUser.setIsManager(true);
        roomUserRepository.save(roomUser);

        log.info("CREATE Chat RoomId: {}", room.getId());

        return roomData;
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
            roomService.plusUserCnt(roomId);
            roomUser = roomUserService.createRoomUser(user, room);
            roomUser = roomUserRepository.findByUserAndRoom(user, room)
                    .orElse(null);
        }

        return "nowUser : " + roomUser.getRoom().getNowUser().toString() + "\n" +
                "room id : " +  roomUser.getRoom().getId();
    }

    // 비공개 인증방 입장시 비밀번호 확인 절차
    @PostMapping("/confirmPwd/{roomId}")
    @ResponseBody
    public boolean confirmPwd(@PathVariable Long roomId, @RequestParam String roomPwd){
        return roomService.confirmPwd(roomId, roomPwd);
    }

    // 인증방 나가기
    @CustomAuthentication
    @GetMapping("/room-out/{roomId}")
    public String roomOut(@PathVariable Long roomId, @RequestAttribute UserContext userContext){
        log.info("del roomId : {}", roomId);
        log.info("del userId : {]", userContext.getUserId());

        Room room = roomRepository.findById(roomId).get();
        User user = userRepository.findById(userContext.getUserId()).get();

        roomService.minusUserCnt(roomId);
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

    // 공지 수정하기
    @CustomAuthentication
    @PostMapping("/edit-info")
    public String editInfo(@RequestBody RoomData roomData, @RequestAttribute UserContext userContext, @RequestParam String txt) {
        Room room = roomRepository.findById(roomData.getRoomId()).get();
        User user = userRepository.findById(userContext.getUserId()).get();
        RoomUser roomUser = roomUserRepository.findByUserAndRoom(user, room).get();

        if (!roomUser.getIsManager()) {
            return "방장이 아닙니다.";
        }

        roomService.editInfo(room.getId(), txt);

        return room.getInfo();
    }
}
