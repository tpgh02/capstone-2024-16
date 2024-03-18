package com.dodo.certification.domain;

import com.dodo.image.domain.Image;
import com.dodo.roomuser.domain.RoomUser;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.time.LocalDateTime;

@Entity
@Builder
@AllArgsConstructor
@NoArgsConstructor
@EntityListeners(AuditingEntityListener.class)
@Data
public class Certification {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "room_user_id")
    private RoomUser roomUser;

    @Enumerated(EnumType.STRING)
    private CertificationStatus status;

    @CreatedDate
    private LocalDateTime createdTime;

    @ManyToOne
    private Image image;

    private Integer voteUp;
    private Integer voteDown;
}
