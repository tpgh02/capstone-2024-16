package com.dodo.certification.domain;

import com.dodo.user.domain.User;
import jakarta.persistence.*;
import lombok.NoArgsConstructor;

@Entity
@NoArgsConstructor
public class Vote {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    private User user;

    @Enumerated(EnumType.STRING)
    private VoteStatus voteStatus;

    @OneToOne
    private Certification certification;
}
