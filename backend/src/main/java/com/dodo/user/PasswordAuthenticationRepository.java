package com.dodo.user;

import com.dodo.user.domain.PasswordAuthentication;
import com.dodo.user.domain.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface PasswordAuthenticationRepository extends JpaRepository<PasswordAuthentication, Long> {
    Optional<PasswordAuthentication> findByUser(User user);
}
