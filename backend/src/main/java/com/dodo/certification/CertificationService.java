package com.dodo.certification;

import com.dodo.certification.domain.Certification;
import com.dodo.certification.domain.CertificationStatus;
import com.dodo.certification.domain.Vote;
import com.dodo.certification.domain.VoteStatus;
import com.dodo.certification.dto.*;
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
    private final VoteRepository voteRepository;
    private final ImageService imageService;

    public CertificationUploadResponseData makeCertification(UserContext userContext, Long roomId, MultipartFile img) throws IOException {
        User user = getUser(userContext);
        Room room = roomRepository.findById(roomId)
                .orElseThrow(() -> new NotFoundException("인증방 정보를 찾을 수 없습니다"));
        RoomUser roomUser = roomUserRepository.findByUserAndRoom(user, room)
                .orElseThrow(() -> new NotFoundException("인증방에 소속되어 있지 않습니다"));
        Image image = imageService.saveImage(img);

        // 테스트용
//        RoomUser roomUser = roomUserRepository.save(new RoomUser(user, room));
//        Room room = roomRepository.save(new Room());
//        log.info("{}", image.getUrl());

        Certification saved = certificationRepository.save(Certification.builder()
                .status(CertificationStatus.WAIT)
                .roomUser(roomUser)
                .image(image)
                .voteUp(0)
                .voteDown(0)
                .build());
        return new CertificationUploadResponseData(saved);
    }

    public CertificationDetailResponseData getCertificationDetail(
            UserContext userContext,
            Long certificationId
    ) {
        User user = getUser(userContext);
        Certification certification = certificationRepository.findById(certificationId)
                .orElseThrow(() -> new NotFoundException("인증 정보를 찾을 수 없습니다"));
        Vote vote = voteRepository.findByUserAndCertification(user, certification).orElse(null);
        return new CertificationDetailResponseData(certification, vote);
    }

    public CertificationDetailResponseData voting(UserContext userContext, VoteRequestData requestData) {
        User user = getUser(userContext);
        Certification certification = certificationRepository.findById(requestData.getCertificationId())
                .orElseThrow(() -> new NotFoundException("인증 정보를 찾을 수 없습니다"));
        Room room = certification.getRoomUser().getRoom();

        Vote vote = voteRepository.findByUserAndCertification(user, certification)
                .orElse(new Vote(user, certification));

        if(vote.getVoteStatus() == VoteStatus.NONE) {
            if(requestData.getVoteStatus() == VoteStatus.UP) certification.addVoteUp();
            else certification.addVoteDown();
        }
        if(vote.getVoteStatus() == VoteStatus.UP && requestData.getVoteStatus() == VoteStatus.DOWN) {
            certification.addVoteDown();
            certification.subVoteUp();
        }
        if(vote.getVoteStatus() == VoteStatus.DOWN && requestData.getVoteStatus() == VoteStatus.UP) {
            certification.addVoteUp();
            certification.subVoteDown();
        }

        vote.setVoteStatus(requestData.getVoteStatus());
        voteRepository.save(vote);


        // TODO
        // 투표 수 다 차면 어떻게 할지
        // 인증 상태 변경
        // (알림 어떻게함)
        if(certification.getVoteUp().equals(room.getNumOfVoteSuccess())) {
            certification.setStatus(CertificationStatus.SUCCESS);
        }

        if(certification.getVoteDown().equals(room.getNumOfVoteFail())) {
            certification.setStatus(CertificationStatus.FAIL);
        }


        return new CertificationDetailResponseData(certification, vote);
    }

    public CertificationDetailResponseData approval(UserContext userContext, ApprovalRequestData requestData) {
        User user = getUser(userContext);
        Certification certification = certificationRepository.findById(requestData.getCertificationId())
                .orElseThrow(() -> new NotFoundException("인증 정보를 찾을 수 없습니다"));
        Room room = certification.getRoomUser().getRoom();
        RoomUser roomUser = roomUserRepository.findByUserAndRoom(user, room)
                .orElseThrow(() -> new NotFoundException("인증방에 소속되어 있지 않습니다"));
        if(roomUser.getIsManager()) {
            certification.setStatus(requestData.getStatus());
        } else {
            // 요청한 사람이 방장이 아니라면 에러
        }

        return new CertificationDetailResponseData(certification, null);
    }


    public List<CertificationListResponseData> getList(UserContext userContext, Long roomId) {
        User user = getUser(userContext);
        Room room = roomRepository.findById(roomId)
                .orElseThrow(() -> new NotFoundException("인증방을 찾을 수 없습니다"));

        List<RoomUser> roomUser = roomUserRepository.findAllByUserAndRoom(user, room)
                .orElseThrow(() -> new NotFoundException("인증방의 회원을 찾을 수 엇습니다"));


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
                .orElseThrow(() -> new NotFoundException("유저를 찾을 수 없습니다"));
    }
}
