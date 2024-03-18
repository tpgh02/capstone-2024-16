package com.dodo.room;

import com.dodo.exception.NotFoundException;
import com.dodo.room.domain.Room;
import com.dodo.room.dto.RoomData;
import com.dodo.room.dto.UserData;
import com.dodo.roomuser.RoomUserRepository;
import com.dodo.roomuser.domain.RoomUser;
import com.dodo.user.UserRepository;
import com.dodo.user.domain.User;
import com.dodo.user.domain.UserContext;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class RoomService {

    private final UserRepository userRepository;
    private final RoomUserRepository roomUserRepository;


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
}
