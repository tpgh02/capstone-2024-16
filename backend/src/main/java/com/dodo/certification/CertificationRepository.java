package com.dodo.certification;

import com.dodo.certification.domain.Certification;
import com.dodo.room.domain.Room;
import com.dodo.roomuser.domain.RoomUser;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface CertificationRepository extends JpaRepository<Certification, Long> {
    Optional<List<Certification>> findAllByRoomUserIn(List<RoomUser> roomUserList);
    Optional<List<Certification>> findAllByRoomUser(RoomUser roomuser);
    Optional<List<Certification>> findAllByRoomUserRoom(Room room);
    Long countAllByRoomUser(RoomUser roomUser);
}
