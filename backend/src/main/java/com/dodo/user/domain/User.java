package com.dodo.user.domain;

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

    @OneToMany(mappedBy = "user")
    private List<RoomUser> roomUsers;

//    TODO
//    private String image;

    public User(AuthenticationType type, String email, Integer mileage) {
        this.authenticationType = type;
        this.email = email;
        this.mileage = mileage;
    }


}
