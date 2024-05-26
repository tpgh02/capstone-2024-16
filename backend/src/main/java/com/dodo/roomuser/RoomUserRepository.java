package com.dodo.roomuser;

import com.dodo.room.domain.Room;
import com.dodo.roomuser.domain.RoomUser;
import com.dodo.user.domain.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface RoomUserRepository extends JpaRepository<RoomUser, Long> {
    Optional<RoomUser> findByUserAndRoom(User user, Room room);
    Optional<List<RoomUser>> findAllByUser(User user);
    Optional<List<RoomUser>> findAllByRoomId(Long roomId);
    Optional<List<RoomUser>> findAllByUserAndRoom(User user, Room room);
}
