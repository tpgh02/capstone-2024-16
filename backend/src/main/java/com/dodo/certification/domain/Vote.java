package com.dodo.certification.domain;

import com.dodo.user.domain.User;
import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@NoArgsConstructor
@Data
public class Vote {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    private User user;

    @Enumerated(EnumType.STRING)
    private VoteStatus voteStatus;

    @ManyToOne
    private Certification certification;

    public Vote(User user, Certification certification) {
        this.user = user;
        this.certification = certification;
        this.voteStatus = VoteStatus.NONE;
    }
}
