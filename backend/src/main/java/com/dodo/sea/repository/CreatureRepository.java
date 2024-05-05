package com.dodo.sea.repository;

import com.dodo.sea.domain.Creature;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface CreatureRepository extends JpaRepository<Creature, Long> {

    List<Creature> findAll(Sort sort);
}
