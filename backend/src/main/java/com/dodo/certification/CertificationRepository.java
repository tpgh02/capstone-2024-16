package com.dodo.certification;

import com.dodo.certification.domain.Certification;
import com.dodo.roomuser.domain.RoomUser;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface CertificationRepository extends JpaRepository<Certification, Long> {
    List<Certification> findAllByRoomUserIn(List<RoomUser> roomUserList);
}
