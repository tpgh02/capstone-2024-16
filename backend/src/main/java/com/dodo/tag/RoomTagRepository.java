package com.dodo.tag;

import com.dodo.room.domain.Room;
import com.dodo.tag.domain.RoomTag;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface RoomTagRepository extends JpaRepository<RoomTag, Long> {

    Optional<List<RoomTag>> findByRoom(Room room);
}
