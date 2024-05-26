package com.dodo.room;

import com.dodo.room.domain.Category;
import com.dodo.room.domain.Room;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface RoomRepository extends JpaRepository<Room, Long> {

    Optional<Room> findById(Long id);

    @Override
    List<Room> findAll();

    Optional<List<Room>> findAllByNameContaining(String name);

    Optional<List<Room>> findAllById(Long id);
    Optional<List<Room>> findAllByCategory(Category category);
}
