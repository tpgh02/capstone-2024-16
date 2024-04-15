package com.dodo.sea.repository;

import com.dodo.sea.domain.Sea;
import com.dodo.user.domain.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface SeaRepository extends JpaRepository<Sea, Long> {

    Optional<Sea> findByUser(User user);
}
