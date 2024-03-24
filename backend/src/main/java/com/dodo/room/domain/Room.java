package com.dodo.room.domain;

import com.dodo.image.domain.Image;
import com.dodo.roomuser.domain.RoomUser;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
import java.util.List;

@Entity
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Setter @Getter
public class Room {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String name;
    private String password;
    private String info;
    private String notice;
    private String category;
    private LocalDateTime endDay;
    private Long maxUser;
    private Long nowUser;
    private String tag;
    private Boolean canChat;

    @ManyToOne
    private Image image;

    // 매일, 최대 3개까지
    // 주간, 주에 몇번
    @Enumerated(EnumType.STRING)
    private Periodicity periodicity;
    private Integer frequency;

    //인증 방식 (AI, 직접)
    @Enumerated(EnumType.STRING)
    private CertificationType certificationType;

    @OneToMany(mappedBy = "room")
    private List<RoomUser> roomUsers;

}
