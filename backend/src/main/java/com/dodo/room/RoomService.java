package com.dodo.room;

import com.dodo.exception.NotFoundException;
import com.dodo.room.dto.RoomData;
import com.dodo.room.dto.UserData;
import com.dodo.roomuser.RoomUserRepository;
import com.dodo.roomuser.domain.RoomUser;
import com.dodo.user.UserRepository;
import com.dodo.user.domain.User;
import com.dodo.room.domain.Room;
import com.dodo.user.domain.UserContext;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
public class RoomService {

    private final UserRepository userRepository;
    private final RoomUserRepository roomUserRepository;
    private final RoomRepository roomRepository;

    public List<RoomData> getMyRoomList(UserContext userContext) {
        User user = userRepository.findById(userContext.getUserId())
                        .orElseThrow(NotFoundException::new);
        return roomUserRepository.findAllByUser(user)
                .orElseThrow(NotFoundException::new)
                .stream()
                .map(RoomUser::getRoom)
                .map(RoomData::new)
                .toList();
    }

    public List<UserData> getUsers(UserContext userContext, Long roomId) {
        return roomUserRepository.findAllByRoomId(roomId)
                .orElseThrow(NotFoundException::new)
                .stream()
                .map(UserData::new) //TODO
                .toList();
    }

    // 채팅방 생성
    public Room creatChatRoom(String roomName, String roomPwd, Long maxUserCnt, String category, String info, String hashtag){
        Room room = Room.builder()
                .name(roomName)
                .password(roomPwd)
                .maxUser(maxUserCnt)
                .nowUser(1L)
                .category(category)
                .info(info)
                .tag(hashtag)
                .build();

        roomRepository.save(room);
        return room;
    }

    // 채팅방 인원 증가
    public void plusUserCnt(Long roomId){
        log.info("plus room Id : {}", roomId);
        Room room = roomRepository.findById(roomId).get();
        room.setNowUser(room.getNowUser()+1);
    }

    // 채팅방 인원 감소
    public void minusUserCnt(Long roomId){
        log.info("room Id : {}", roomId);
        Room room = roomRepository.findById(roomId).get();
        room.setNowUser(room.getNowUser()-1);
    }

    // 채팅방 삭제
    public void deleteRoom(Long roomId){
        Room room = roomRepository.findById(roomId).
                orElse(null);
        if (room == null){
            System.out.println("room = null");
            return;
        }
        roomRepository.delete(room);
    }

    // 채팅방 공지 수정
    public void editInfo(Long roomId, String txt){
        Room room = roomRepository.findById(roomId).get();
        room.setInfo(txt);
        roomRepository.save(room);
    }
}
