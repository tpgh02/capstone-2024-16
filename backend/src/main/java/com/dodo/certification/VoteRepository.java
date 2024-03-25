package com.dodo.certification;

import com.dodo.certification.domain.Certification;
import com.dodo.certification.domain.Vote;
import com.dodo.user.domain.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface VoteRepository extends JpaRepository<Vote, Long> {
    Optional<Vote> findByUserAndCertification(User user, Certification certification);
}
