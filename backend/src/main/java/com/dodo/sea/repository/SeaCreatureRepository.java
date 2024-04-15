package com.dodo.sea.repository;

import com.dodo.sea.domain.SeaCreature;
import org.springframework.data.jpa.repository.JpaRepository;

public interface SeaCreatureRepository extends JpaRepository<SeaCreature, Long> {
}
