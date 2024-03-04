package com.dodo.user.domain;

import jakarta.persistence.*;

import lombok.*;

@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name="MEMBER")
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Enumerated(EnumType.STRING)
    private AuthenticationType authenticationType;

    private String name;
    private String email;
    private Integer mileage;

    public User(AuthenticationType type, String email, Integer mileage){
        this.authenticationType = type;
        this.email = email;
        this.mileage = mileage;
    }
}