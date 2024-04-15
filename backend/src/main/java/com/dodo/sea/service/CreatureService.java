package com.dodo.sea.service;

import com.dodo.image.ImageService;
import com.dodo.image.domain.Image;
import com.dodo.sea.domain.Creature;
import com.dodo.sea.dto.CreatureData;
import com.dodo.sea.repository.CreatureRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

@Service
@RequiredArgsConstructor
@Slf4j
public class CreatureService {
    private final CreatureRepository creatureRepository;
    private final ImageService imageService;


    public CreatureData createCreature(String name, String info, Integer price, MultipartFile img) throws IOException {

        Image image = imageService.save(img);

        Creature creature = Creature.builder()
                .name(name)
                .info(info)
                .price(price)
                .image(image)
                .build();

        creatureRepository.save(creature);

        return new CreatureData(creature);
    }
}
