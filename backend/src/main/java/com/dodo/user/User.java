package com.dodo.user;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Getter
@NoArgsConstructor
@Builder
@AllArgsConstructor
@Table(name = "user")
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long userId;

    public enum AuthenticationType{
        PASSWORD, SOCIAL;
    }
    // password or social
    @Enumerated(EnumType.STRING)
    private AuthenticationType authenticationType;
    private String email;
    private String name;
    private Integer mileage;

//    TODO
//    private String image;

    public User(AuthenticationType type, String email, Integer mileage) {
        this.authenticationType = type;
        this.email = email;
        this.mileage = mileage;
    }


}
