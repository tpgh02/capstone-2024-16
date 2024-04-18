package com.dodo.sea.repository;

import com.dodo.sea.domain.Creature;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CreatureRepository extends JpaRepository<Creature, Long> {
}
