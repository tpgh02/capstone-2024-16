package com.dodo.room.domain;

import com.dodo.image.domain.Image;
import com.dodo.roomuser.domain.RoomUser;
import com.dodo.tag.domain.RoomTag;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.ColumnDefault;

import java.time.LocalDateTime;
import java.util.List;

@Entity
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Getter
public class Room {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String name;
    private String password;
    @Setter private String info;
    private String notice;
    private LocalDateTime endDay;
    @Builder.Default
    private Long maxUser = 50L;
    @Setter private Long nowUser;
    private Boolean canChat;
    private Integer numOfVoteSuccess;
    private Integer numOfVoteFail;
    private Boolean isFull;

    // 기상, 공부 인증일 경우에 기준 시각
    private Integer certificationTime;

    // 그룹일 때
    private Integer numOfGoal;
    private String goal;
    @Setter
    private Integer nowGoal;

    @ManyToOne @Setter
    private Image image;

    // 매일, 최대 3개까지
    // 주간, 주에 몇번
    @Enumerated(EnumType.STRING)
    private Periodicity periodicity;
    private Integer frequency;

    //인증 방식 (투표, 방장 승인)
    @Enumerated(EnumType.STRING)
    private CertificationType certificationType;

    // 방 타입 (ai, 일반, 그룹)
    @Enumerated(EnumType.STRING)
    private RoomType roomType;

    // 카테고리
    @Enumerated(EnumType.STRING)
    private Category category;

    @OneToMany(mappedBy = "room")
    private List<RoomUser> roomUsers;

    @OneToMany(mappedBy = "room")
    private List<RoomTag> roomTags;

    // 인증방 기능 설정
    public void update(String name, String info,
                       Long maxUser, Boolean canChat, Integer numOfVoteSuccess,
                       Integer numOfVoteFail, Periodicity periodicity,
                       Integer frequency, CertificationType certificationType, String password) {
        if (name != null){this.name = name;}
        if (info != null){this.info = info;}
        if (password != null){this.password = password;}
        if (canChat != null){this.canChat = canChat;}
        if (numOfVoteSuccess != null){this.numOfVoteSuccess = numOfVoteSuccess;}
        if (numOfVoteFail != null){this.numOfVoteFail = numOfVoteFail;}
        if (periodicity != null){this.periodicity = periodicity;}
        if (frequency != null){this.frequency = frequency;}
        if (certificationType != null){this.certificationType = certificationType;}
        if (maxUser != null){
            this.maxUser = maxUser;
            this.isFull = maxUser.equals(this.nowUser);
        }
    }

}
