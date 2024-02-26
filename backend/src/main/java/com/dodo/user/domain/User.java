package com.dodo.user.domain;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

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
    private String password;
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
