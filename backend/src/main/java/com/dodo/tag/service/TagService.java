package com.dodo.tag.service;

import com.dodo.tag.domain.Tag;
import com.dodo.tag.repository.TagRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class TagService {

    private final TagRepository tagRepository;
    public Tag createTag(String name) {
        Tag tag = Tag.builder()
                .name(name)
                .build();

        tagRepository.save(tag);

        return tag;
    }
}
