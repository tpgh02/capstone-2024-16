package com.dodo.roomuser;

import com.dodo.certification.domain.Certification;
import com.dodo.certification.domain.CertificationStatus;
import com.dodo.exception.NotFoundException;
import com.dodo.room.RoomRepository;
import com.dodo.room.domain.Room;
import com.dodo.room.dto.RoomListData;
import com.dodo.roomuser.domain.RoomUser;
import com.dodo.user.UserRepository;
import com.dodo.user.domain.User;
import com.dodo.user.domain.UserContext;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
public class RoomUserService {

    private final RoomUserRepository roomUserRepository;
    private final UserRepository userRepository;
    private final RoomRepository roomRepository;

    public void createRoomUser(UserContext userContext, Long roomId) {
        Room room = roomRepository.findById(roomId).orElseThrow(NotFoundException::new);
        User user = userRepository.findById(userContext.getUserId()).orElseThrow(NotFoundException::new);
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
            log.info("없는 유저입니다.");
            return;
        }
        if (roomUser.getIsManager()) {
            List<RoomUser> roomUsers = roomUserRepository.findAllByRoomId(roomId).get();
            if (roomUsers.size() > 1) {
                RoomUser ru = roomUsers.get(1);
                ru.setIsManager(true);
                roomUserRepository.save(ru);
            }
        }

        roomUserRepository.delete(roomUser);

        log.info("삭제한 room : {}, user : {}", roomUser.getRoom().getId(), roomUser.getUser().getId());
    }

    // TODO
    // 유저가 방에 처음 입장하면 인증 정보가 없음. 그래서 certificationList가 empty일 때 상태를 지정해놓음. (임시)
    public CertificationStatus getCertificationStatus(UserContext userContext, RoomListData roomListData){
        User user = userRepository.findById(userContext.getUserId()).orElseThrow(NotFoundException::new);
        Room room = roomRepository.findById(roomListData.getRoomId()).orElseThrow(NotFoundException::new);
        List<Certification> certificationList = roomUserRepository.findByUserAndRoom(user, room).orElseThrow(NotFoundException::new)
                .getCertification();

        // 기본 FAIL 로 설정해둠
        if (certificationList == null || certificationList.isEmpty()) { return CertificationStatus.FAIL; }

        return certificationList.get(certificationList.size() - 1).getStatus();
    }
}
