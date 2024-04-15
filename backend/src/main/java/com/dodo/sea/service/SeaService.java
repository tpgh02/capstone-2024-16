package com.dodo.sea.service;

import com.dodo.exception.NotFoundException;
import com.dodo.sea.domain.Creature;
import com.dodo.sea.domain.Sea;
import com.dodo.sea.domain.SeaCreature;
import com.dodo.sea.dto.CreatureData;
import com.dodo.sea.repository.CreatureRepository;
import com.dodo.sea.repository.SeaCreatureRepository;
import com.dodo.sea.repository.SeaRepository;
import com.dodo.user.UserRepository;
import com.dodo.user.domain.User;
import com.dodo.user.domain.UserContext;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class SeaService {

    private final SeaRepository seaRepository;
    private final SeaCreatureRepository seaCreatureRepository;
    private final UserRepository userRepository;
    private final CreatureRepository creatureRepository;

    public Sea SaveSea(User user) {
        Sea sea = Sea.builder()
                .user(user)
                .build();

        seaRepository.save(sea);

        return sea;
    }

    public void ActivateCreature(SeaCreature seaCreature) {
        seaCreature.setActivate(true);
    }
    public void DeactivateCreature(SeaCreature seaCreature) {
        seaCreature.setActivate(false);
    }

    public Boolean purchaseCreature(UserContext userContext, CreatureData creatureData) {

        User user = userRepository.findById(userContext.getUserId()).orElseThrow(NotFoundException::new);
        Sea sea = seaRepository.findByUser(user).orElseThrow(NotFoundException::new);
        Creature creature = creatureRepository.findById(creatureData.getCreatureId()).orElseThrow(NotFoundException::new);

        // 유저가 갖고 있는 마일리지가 적은데 구매하려 했을 때 false를 return
        if (creature.getPrice() > user.getMileage()) {
            return false;
        }

        user.updateMileage(user.getMileage() - creature.getPrice()); // 유저의 마일리지 차감

        SeaCreature seaCreature = SeaCreature.builder()
                .creature(creature)
                .sea(sea)
                .activate(false)
                .build();

        userRepository.save(user);
        seaCreatureRepository.save(seaCreature);

        return true;
    }
}
