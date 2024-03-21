package com.dodo.room;

import com.dodo.room.domain.Room;
import com.dodo.roomuser.domain.RoomUser;
import com.dodo.user.domain.User;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
@Slf4j
public class RoomService {

    private final RoomRepository roomRepository;

    // 채팅방 생성
    public Room creatChatRoom(String roomName, String roomPwd, Long maxUserCnt, String category, String info){
        Room room = Room.builder()
                .name(roomName)
                .password(roomPwd)
                .maxUser(maxUserCnt)
                .nowUser(1L)
                .category(category)
                .info(info)
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
    public void deleteRoom(Long roomId){
        Room room = roomRepository.findById(roomId).
                orElse(null);
        if (room == null){
            System.out.println("room = null");
            return;
        }
        roomRepository.delete(room);
    }

    public void editInfo(Long roomId, String txt){
        Room room = roomRepository.findById(roomId).get();
        room.setInfo(txt);
        roomRepository.save(room);
    }

}
