package com.dodo.sea.service;

import com.dodo.exception.NotFoundException;
import com.dodo.image.ImageService;
import com.dodo.image.domain.Image;
import com.dodo.sea.domain.Creature;
import com.dodo.sea.domain.SeaCreature;
import com.dodo.sea.dto.CreatureData;
import com.dodo.sea.repository.CreatureRepository;
import com.dodo.sea.repository.SeaCreatureRepository;
import com.dodo.user.UserRepository;
import com.dodo.user.domain.User;
import com.dodo.user.domain.UserContext;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
public class CreatureService {
    private final CreatureRepository creatureRepository;
    private final ImageService imageService;
    private final SeaCreatureRepository seaCreatureRepository;
    private final UserRepository userRepository;


    public CreatureData createCreature(String name, String info, Integer price
                                       //,MultipartFile img
                                       ) throws IOException {

        //Image image = imageService.save(img);

        Creature creature = Creature.builder()
                .name(name)
                .info(info)
                .price(price)
                //.image(image)
                .build();

        creatureRepository.save(creature);

        return new CreatureData(creature);
    }

    public void ActivateCreature(SeaCreature seaCreature) {
        seaCreature.setActivate(true);
    }
    public void DeactivateCreature(SeaCreature seaCreature) {
        seaCreature.setActivate(false);
    }

    public Boolean purchaseCreature(UserContext userContext, CreatureData creatureData) {

        User user = userRepository.findById(userContext.getUserId()).orElseThrow(NotFoundException::new);
        Creature creature = creatureRepository.findById(creatureData.getCreatureId()).orElseThrow(NotFoundException::new);

        // 유저가 갖고 있는 마일리지가 적은데 구매하려 했을 때 false를 return
        if (creature.getPrice() > user.getMileage()) {
            return false;
        }

        user.updateMileage(user.getMileage() - creature.getPrice()); // 유저의 마일리지 차감

        SeaCreature seaCreature = SeaCreature.builder()
                .creature(creature)
                .user(user)
                .activate(false)
                .build();

        userRepository.save(user);
        seaCreatureRepository.save(seaCreature);

        return true;
    }

    // 상점에서 모든 생물을 보여주기 위한 함수
    public List<CreatureData> getAllCreature() {
        return creatureRepository.findAll().stream()
                .map(CreatureData::new)
                .toList();
    }

    // 유저의 생물을 보여주기 위한 함수
    public List<CreatureData> getUserCreature(UserContext userContext) {
        User user = userRepository.findById(userContext.getUserId()).orElseThrow(NotFoundException::new);

        return seaCreatureRepository.findAllByUser(user).orElseThrow(NotFoundException::new).stream()
                .map(SeaCreature::getCreature)
                .map(CreatureData::new)
                .toList();
    }
}
