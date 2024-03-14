package com.dodo.chat.service;

import com.dodo.room.RoomRepository;
import com.dodo.room.domain.Room;
import com.dodo.roomuser.domain.RoomUser;
import jakarta.persistence.EntityManager;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Service
@Getter
@RequiredArgsConstructor
@Slf4j
public class ChatRoomService {
    EntityManager em;
    private final RoomRepository roomRepository;

    // 채팅방 생성
    public Room creatChatRoom(String roomName, String roomPwd, Long maxUserCnt, String category, String info){
        Room room = Room.builder()
                .name(roomName)
                .password(roomPwd)
                .maxUser(maxUserCnt)
                .nowUser(0L)
                .category(category)
                .info(info)
                .build();

        roomRepository.save(room);
        return room;
    }

    // 채팅방 인원 증가
    public void plusUserCnt(Long roomId){
        Room room = em.find(RoomUser.class, roomId).getRoom();
        room.setNowUser(room.getNowUser()+1);
    }

    // 채팅방 인원 감소
    public void minusUserCnt(Long roomId){
        Room room = em.find(RoomUser.class, roomId).getRoom();
        room.setNowUser(room.getNowUser()-1);
    }

}
