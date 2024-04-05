package com.dodo.tag;

import com.dodo.exception.NotFoundException;
import com.dodo.room.RoomRepository;
import com.dodo.room.domain.Room;
import com.dodo.tag.domain.RoomTag;
import com.dodo.tag.dto.TagResponseDTO;
import com.dodo.tag.repository.RoomTagRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/v1/tag")
@Slf4j
public class TagController {

    private final RoomRepository roomRepository;
    private final RoomTagRepository roomTagRepository;


    // room의 tag 이름 가져오기
    @GetMapping("/get-tags/{roomId}")
    @ResponseBody
    public TagResponseDTO getTags(@PathVariable Long roomId){

        List<RoomTag> roomTag = roomTagRepository
                .findByRoom(roomRepository.findById(roomId).orElseThrow(NotFoundException::new))
                .orElseThrow(NotFoundException::new);
        log.info("roomTag List : {}", roomTag);

        return new TagResponseDTO(roomTag.stream()
                .map(tagName -> tagName.getTag().getName())
                .collect(Collectors.toList()));
    }
}
