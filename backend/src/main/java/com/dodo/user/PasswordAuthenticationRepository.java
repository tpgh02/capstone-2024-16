package com.dodo.user;

import com.dodo.user.domain.PasswordAuthentication;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PasswordAuthenticationRepository extends JpaRepository<PasswordAuthentication, Long> {
}
