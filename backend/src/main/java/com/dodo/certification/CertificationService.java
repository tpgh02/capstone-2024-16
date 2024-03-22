package com.dodo.certification;

import com.dodo.certification.domain.Certification;
import com.dodo.certification.domain.CertificationStatus;
import com.dodo.certification.dto.CertificationListResponseData;
import com.dodo.certification.dto.CertificationUploadResponseData;
import com.dodo.exception.NotFoundException;
import com.dodo.image.ImageService;
import com.dodo.image.domain.Image;
import com.dodo.room.RoomRepository;
import com.dodo.room.domain.Room;
import com.dodo.roomuser.RoomUserRepository;
import com.dodo.roomuser.domain.RoomUser;
import com.dodo.user.UserRepository;
import com.dodo.user.domain.User;
import com.dodo.user.domain.UserContext;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class CertificationService {

    private final CertificationRepository certificationRepository;
    private final UserRepository userRepository;
    private final RoomRepository roomRepository;
    private final RoomUserRepository roomUserRepository;
    private final ImageService imageService;

    public CertificationUploadResponseData makeCertification(UserContext userContext, Long roomId, MultipartFile img) throws IOException {
        User user = getUser(userContext);
        Room room = roomRepository.findById(roomId)
                .orElseThrow(NotFoundException::new);
//        Room room = roomRepository.save(new Room());

        RoomUser roomUser = roomUserRepository.findByUserAndRoom(user, room)
                        .orElseThrow(NotFoundException::new);
//        RoomUser roomUser = roomUserRepository.save(new RoomUser(user, room));

        Image image = imageService.saveImage(img);
//        log.info("{}", image.getUrl());

        Certification saved = certificationRepository.save(Certification.builder()
                .status(CertificationStatus.WAIT)
                .roomUser(roomUser)
                .image(image)
                .build());
        return new CertificationUploadResponseData(saved);
    }

    public void voting(UserContext userContext, Long certificationId) {


    }

    public void approval(UserContext userContext, Long certificationId) {

    }

    public List<CertificationListResponseData> getList(UserContext userContext, Long roomId) {
        User user = getUser(userContext);
        Room room = roomRepository.findById(roomId)
                .orElseThrow(NotFoundException::new);

        List<RoomUser> roomUser = roomUserRepository.findAllByUserAndRoom(user, room)
                .orElseThrow(NotFoundException::new);


        // 날짜비교
        // TODO
        // 일일 인증일 경우만 따진다 일단
        // periodicity를 이용하여 나중에 수정해야 함.
        LocalDateTime today = LocalDateTime.now();
        String todayString = today.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));


        List<CertificationGroup> groupList = new ArrayList<>();

        // -> 인증 기록들 중에 오늘인것 찾는다.
        // -> 같은 유저것들로 묶는다.
        // -> 맵의 리스트를 돌며 wait, success 개수를 센다.
        // -> roomuser와 함께 클래스에 넣어서 리스트를 만든다.
        certificationRepository.findAllByRoomUserIn(roomUser)
                .stream()
                .filter(c -> c.getCreatedTime()
                        .format(DateTimeFormatter.ofPattern("yyyy-MM-dd"))
                        .equals(todayString))
                .collect(Collectors.groupingBy(Certification::getRoomUser))
                .forEach((ru, certificationList) -> {
                    CertificationGroup group = new CertificationGroup(ru);
                    certificationList
                            .forEach(c -> {
                                if(c.getStatus() == CertificationStatus.WAIT) group.addWait();
                                else if(c.getStatus() == CertificationStatus.SUCCESS) group.addSuccess();
                            });
                    groupList.add(group);
                });

        return groupList.stream()
                .map(CertificationListResponseData::new)
                .toList();

        /*
        원하는 응답값
        {
            certificationList : [
                "userId" : 1,
                "username": "hello",
                "userImage" : {
                    "url" : "sdfasdfsdfasdfadfafd"
                },
                "max" : 3,
                "success" : 1,
                "wait" : 1,
                "certification" : false
            ]

        }
        */
    }

    @Data
    @EqualsAndHashCode
    public static class CertificationGroup {
        private RoomUser roomUser;
        private Integer wait;
        private Integer success;
        public CertificationGroup(RoomUser roomUser) {
            this.roomUser = roomUser;
            this.wait = 0;
            this.success = 0;
        }
        public void addWait() { this.wait += 1; }
        public void addSuccess() { this.success += 1; }
    }

    private User getUser(UserContext userContext) {
        return userRepository.findById(userContext.getUserId())
                .orElseThrow(NotFoundException::new);
    }
}
