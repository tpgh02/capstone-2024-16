package com.dodo.certification.domain;

import com.dodo.image.domain.Image;
import com.dodo.roomuser.domain.RoomUser;
import jakarta.persistence.*;
import org.springframework.data.annotation.CreatedDate;

import java.time.LocalDateTime;

@Entity
public class Certification {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "room_user_id")
    private RoomUser roomUser;

    @CreatedDate
    private LocalDateTime createdTime;

    @OneToOne
    private Image iamge;
}
