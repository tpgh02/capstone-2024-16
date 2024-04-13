package com.dodo.roomuser;

import com.dodo.exception.NotFoundException;
import com.dodo.room.RoomRepository;
import com.dodo.room.domain.Room;
import com.dodo.roomuser.domain.RoomUser;
import com.dodo.user.UserRepository;
import com.dodo.user.domain.User;
import com.dodo.user.domain.UserContext;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
@Slf4j
public class RoomUserService {

    private final RoomUserRepository roomUserRepository;
    private final UserRepository userRepository;
    private final RoomRepository roomRepository;

    public void createRoomUser(UserContext userContext, Long roomId) {
        Room room = roomRepository.findById(roomId).orElseThrow(NotFoundException::new);
        log.info("room ok");
        User user = userRepository.findById(userContext.getUserId()).orElseThrow(NotFoundException::new);
        log.info("user ok");
        RoomUser roomUser = RoomUser.builder()
                .user(user)
                .room(room)
                .build();

        roomUserRepository.save(roomUser);
    }

    public void setManager(UserContext userContext, Room room){
        User user = userRepository.findById(userContext.getUserId()).orElseThrow(NotFoundException::new);
        RoomUser roomUser = roomUserRepository.findByUserAndRoom(user, room).orElseThrow(NotFoundException::new);

        roomUser.setIsManager(true);
        roomUserRepository.save(roomUser);
    }

    // 룸유저 연결 엔티티 삭제
    public void deleteChatRoomUser(Long roomId, Long userId){
        Room room = roomRepository.findById(roomId).orElseThrow(NotFoundException::new);
        User user = userRepository.findById(userId).orElseThrow(NotFoundException::new);

        RoomUser roomUser = roomUserRepository.findByUserAndRoom(user, room)
                .orElse(null);
        if (roomUser == null) {
            System.out.println("roomUser = null");
            return;
        }
        roomUserRepository.delete(roomUser);

        log.info("삭제한 room : {}, user : {}", roomUser.getRoom().getId(), roomUser.getUser().getId());
    }
}
