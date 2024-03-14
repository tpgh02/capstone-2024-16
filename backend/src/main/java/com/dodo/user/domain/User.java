package com.dodo.user.domain;

import com.dodo.image.domain.Image;
import com.dodo.roomuser.domain.RoomUser;
import jakarta.persistence.*;
import lombok.*;

import java.util.List;

@Entity
@Getter
@NoArgsConstructor
@Builder
@AllArgsConstructor
@Table(name = "user")
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // password or social
    @Enumerated(EnumType.STRING)
    private AuthenticationType authenticationType;
    private String email;
    private String name;
    private Integer mileage;
    private String introduceMessage;

    @OneToMany(mappedBy = "user")
    private List<RoomUser> roomUsers;

    @OneToOne
    private Image image;
}
