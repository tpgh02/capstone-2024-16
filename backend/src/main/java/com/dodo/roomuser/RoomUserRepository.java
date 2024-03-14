package com.dodo.roomuser;

import com.dodo.room.domain.Room;
import com.dodo.roomuser.domain.RoomUser;
import com.dodo.user.domain.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface RoomUserRepository extends JpaRepository<RoomUser, Long> {
    Optional<RoomUser> findByUserAndRoom(User user, Room room);
}
