package com.dodo.certification.domain;

import com.dodo.image.domain.Image;
import com.dodo.roomuser.domain.RoomUser;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.CreatedDate;

import java.time.LocalDateTime;

@Entity
@Builder
@AllArgsConstructor
@NoArgsConstructor
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

    @OneToOne
    private Image iamge;
}
