package com.dodo.tag;


import com.dodo.room.domain.Room;
import com.dodo.tag.domain.Tag;
import com.dodo.tag.domain.RoomTag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
public class RoomTagService {

    private final TagService tagService;
    private final TagRepository tagRepository;
    private final RoomTagRepository roomTagRepository;

    public void saveRoomTag(Room room, List<String> tags){

        log.info("tag list : {}", tags);
        if (tags == null) return;

        tags.stream()
                .map(tagName -> tagRepository.findByName(tagName).orElseGet(() -> tagService.createTag(tagName)))
                .forEach(tag -> mapRoomTag(room, tag));
    }

    public Long mapRoomTag(Room room, Tag tag){
        return roomTagRepository.save(new RoomTag(room, tag)).getId();
    }
}
