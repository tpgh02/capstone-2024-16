package com.dodo.tag.repository;

import com.dodo.room.domain.Room;
import com.dodo.tag.domain.RoomTag;
import com.dodo.tag.domain.Tag;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface RoomTagRepository extends JpaRepository<RoomTag, Long> {

    Optional<List<RoomTag>> findAllByRoom(Room room);

    Optional<List<RoomTag>> findAllByTag(Tag tag);
}
