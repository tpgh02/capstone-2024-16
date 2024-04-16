package com.dodo.sea.repository;

import com.dodo.sea.domain.Creature;
import com.dodo.sea.domain.SeaCreature;
import com.dodo.user.domain.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface SeaCreatureRepository extends JpaRepository<SeaCreature, Long> {
    Optional<List<SeaCreature>> findAllByUser(User user);
    Optional<SeaCreature> findByUserAndCreature(User user, Creature creature);
}
