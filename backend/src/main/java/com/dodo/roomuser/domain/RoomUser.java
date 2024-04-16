package com.dodo.roomuser.domain;

import com.dodo.certification.domain.Certification;
import com.dodo.room.domain.Room;
import com.dodo.user.domain.User;
import jakarta.persistence.*;
import lombok.*;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.time.LocalDateTime;
import java.util.List;

@Entity
@Getter
@Builder
@AllArgsConstructor
@EntityListeners(AuditingEntityListener.class)
@NoArgsConstructor
public class RoomUser {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Builder.Default
    @Setter
    private Boolean isManager = false;

    @ManyToOne
    private User user;

    @CreatedDate
    private LocalDateTime createdTime;

    @ManyToOne
    private Room room;

    @OneToMany(mappedBy = "roomUser")
    private List<Certification> certification;

    public RoomUser(User user, Room room) {
        this.room = room;
        this.user = user;
    }
}
