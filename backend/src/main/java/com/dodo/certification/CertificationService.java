package com.dodo.certification;

import com.dodo.certification.domain.Certification;
import com.dodo.certification.domain.CertificationStatus;
import com.dodo.certification.domain.Vote;
import com.dodo.certification.domain.VoteStatus;
import com.dodo.certification.dto.*;
import com.dodo.exception.NotFoundException;
import com.dodo.exception.UnauthorizedException;
import com.dodo.image.ImageService;
import com.dodo.image.domain.Image;
import com.dodo.room.RoomRepository;
import com.dodo.room.domain.Category;
import com.dodo.room.domain.Periodicity;
import com.dodo.room.domain.Room;
import com.dodo.room.domain.RoomType;
import com.dodo.roomuser.RoomUserRepository;
import com.dodo.roomuser.domain.RoomUser;
import com.dodo.statistics.StatisticsService;
import com.dodo.user.UserRepository;
import com.dodo.user.domain.User;
import com.dodo.user.domain.UserContext;
import jakarta.transaction.Transactional;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.time.DayOfWeek;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class CertificationService {

    @Value("${ai.server-url}")
    private String AI_SERVER_URL;


    private final CertificationRepository certificationRepository;
    private final UserRepository userRepository;
    private final RoomRepository roomRepository;
    private final RoomUserRepository roomUserRepository;
    private final VoteRepository voteRepository;
    private final ImageService imageService;
    private final StatisticsService statisticsService;

    private static final int DAILY_SUCCESS_UPDATE_MILEAGE = 10;
    private static final int WEEKLY_SUCCESS_UPDATE_MILEAGE = 50;

    public CertificationUploadResponseData makeCertification(UserContext userContext, Long roomId, MultipartFile img) throws IOException {
        User user = getUser(userContext);
        Room room = roomRepository.findById(roomId)
                .orElseThrow(() -> new NotFoundException("인증방 정보를 찾을 수 없습니다"));
        RoomUser roomUser = roomUserRepository.findByUserAndRoom(user, room)
                .orElseThrow(() -> new NotFoundException("인증방에 소속되어 있지 않습니다"));
        Image image = imageService.save(img);

        // 테스트용
//        RoomUser roomUser = roomUserRepository.save(new RoomUser(user, room));
//        Room room = roomRepository.save(new Room());
//        log.info("{}", image.getUrl());

        Certification certification = certificationRepository.save(Certification.builder()
                .status(CertificationStatus.WAIT)
                .roomUser(roomUser)
                .image(image)
                .voteUp(0)
                .voteDown(0)
                .build());

        // 기상인증인 경우
        if(room.getCategory() == Category.WAKEUP) {
            // TODO -> 시간이 잘 나오나?

        }


        // AI인증방인 경우 AI에 요청 보내기
        if(room.getRoomType() == RoomType.AI) {
            transferToAi(room, certification);
        }

        upCertificateTime(roomId, userContext);
        return new CertificationUploadResponseData(certification);
    }

    // TODO
    //  AI api URL
    //  반환형식 확인.
    //  전달해주면 바로 반환되는지 아니면 컨트롤러로 나중에 보내줄건지
    private void transferToAi(Room room, Certification certification) {
        RestTemplate rt = new RestTemplate();

        AiRequestData aiRequestData = AiRequestData.builder()
                .certificationId(certification.getId())
                .category(room.getCategory())
                .image(certification.getImage().getUrl())
                .build();

        HttpHeaders headers = new HttpHeaders();
        headers.add("Content-Type", "application/json");

        HttpEntity<AiRequestData> entity = new HttpEntity<AiRequestData>(aiRequestData, headers);

        // TODO
        //  응답을 string 말고 클래스 만들어서 다시 하기
        ResponseEntity<String> reponse =  rt.exchange(AI_SERVER_URL, HttpMethod.POST, entity, String.class);
    }


    public CertificationDetailResponseData getCertificationDetail(
            UserContext userContext,
            Long certificationId
    ) {
        User user = getUser(userContext);
        Certification certification = certificationRepository.findById(certificationId)
                .orElseThrow(() -> new NotFoundException("인증 정보를 찾을 수 없습니다"));
        Vote vote = voteRepository.findByUserAndCertification(user, certification).orElse(null);
        Room room = certification.getRoomUser().getRoom();
        return new CertificationDetailResponseData(certification, vote, room);
    }

    @Transactional
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
        // 인증 완료, 실패시 알림 제공
        if(certification.getVoteUp().equals(room.getNumOfVoteSuccess())) {
            certification.setStatus(CertificationStatus.SUCCESS);
            successCertificationToUpdateMileage(certification);
        }

        if(certification.getVoteDown().equals(room.getNumOfVoteFail())) {
            certification.setStatus(CertificationStatus.FAIL);
            downCertificateTime(room.getId(), userContext);
        }


        return new CertificationDetailResponseData(certification, vote, room);
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
            if(certification.getStatus() == CertificationStatus.SUCCESS) {
                successCertificationToUpdateMileage(certification);
            }
        } else {
            throw new UnauthorizedException("방장이 아닙니다");
        }

        return new CertificationDetailResponseData(certification, null, room);
    }


    public List<CertificationListResponseData> getList(UserContext userContext, Long roomId) {
        User user = getUser(userContext);
        Room room = roomRepository.findById(roomId)
                .orElseThrow(() -> new NotFoundException("인증방을 찾을 수 없습니다"));

        List<RoomUser> roomUserList = roomUserRepository.findAllByUserAndRoom(user, room)
                .orElseThrow(() -> new NotFoundException("인증방의 회원을 찾을 수 엇습니다"));


        LocalDateTime today = LocalDateTime.now();

        List<CertificationGroup> groupList = new ArrayList<>();

        // -> 인증 기록들 중에 오늘인것 찾는다.
        // -> 주간 인증의 경우 이번주의 인증 기록들을 찾는다.
        // -> 같은 유저것들로 묶는다.
        if(room.getPeriodicity() == Periodicity.DAILY) {

            String todayString = today.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
            Map<RoomUser, List<Certification>> certificationMap = certificationRepository.findAllByRoomUserIn(roomUserList)
                    .orElse(new ArrayList<>())
                    .stream()
                    .filter(c -> c.getCreatedTime()
                            .format(DateTimeFormatter.ofPattern("yyyy-MM-dd"))
                            .equals(todayString))
                    .collect(Collectors.groupingBy(Certification::getRoomUser));

            grouping(roomUserList, groupList, certificationMap);

        } else if(room.getPeriodicity() == Periodicity.WEEKLY){

            List<LocalDateTime> thisWeek = getThisWeek();
            Map<RoomUser, List<Certification>> certificationMap = certificationRepository.findAllByRoomUserIn(roomUserList)
                    .orElse(new ArrayList<>())
                    .stream()
                    .filter(c -> {
                        LocalDateTime ctime = c.getCreatedTime();
                        return ctime.isAfter(thisWeek.get(0)) && ctime.isBefore(thisWeek.get(1));
                    })
                    .collect(Collectors.groupingBy(Certification::getRoomUser));

            grouping(roomUserList, groupList, certificationMap);

        }

        return groupList.stream()
                .map(CertificationListResponseData::new)
                .toList();
    }

    // 일단위, 주단위로 모인 인증들을 토대로 인증방에서 어떻게 보여줄지 그룹핑함
    // -> 맵의 리스트를 돌며 wait, success 개수를 센다.
    // -> roomuser와 함께 클래스에 넣어서 리스트를 만든다.
    private List<CertificationListResponseData> grouping(List<RoomUser> roomUserList, List<CertificationGroup> groupList, Map<RoomUser, List<Certification>> certificationMap) {
        roomUserList.forEach(
                roomUser -> {
                    CertificationGroup group = new CertificationGroup(roomUser);
                    List<Certification> certificationList = certificationMap.get(roomUser);
                    if(certificationList != null) {
                        certificationList
                                .forEach(c -> {
                                    if(c.getStatus() == CertificationStatus.WAIT) group.addWait();
                                    else if(c.getStatus() == CertificationStatus.SUCCESS) group.addSuccess();
                                });
                    }
                    groupList.add(group);
                }
        );

        return groupList.stream()
                .map(CertificationListResponseData::new)
                .toList();
    }

    // AI로부터 정보를 받아와 인증 여부를 파악함.
    public void analyze(AiResponseData aiResponseData) {
        Category category = aiResponseData.getCategory();
        Certification certification = certificationRepository.findById(aiResponseData.getCertificationId())
                .orElseThrow(() -> new NotFoundException("인증 정보를 찾을 수 없습니다"));
        if(aiResponseData.getCode() == 500) {
            //
            return ;
        }

        if(category == Category.STUDY) {

        } else if(category == Category.GYM) {

        }
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

    private List<LocalDateTime> getThisWeek() {
        LocalDateTime now = LocalDateTime.now();
        DayOfWeek dayOfWeek = now.getDayOfWeek();
        LocalDateTime sunday = now.plusDays(7 - dayOfWeek.getValue()).with(LocalTime.MAX);
        LocalDateTime monday = now.minusDays(6).with(LocalTime.MIN);
        return Arrays.asList(monday, sunday);
    }

    // 성공한 인증에 대해서
    // 일간인증인지 주간인증인지 파악하고
    // 조건을 만족한다면 마일리지를 제공
    private void successCertificationToUpdateMileage(Certification certification) {
        User successUser = certification.getRoomUser().getUser();
        Room room = certification.getRoomUser().getRoom();

        if(room.getPeriodicity() == Periodicity.DAILY) {
            // 일간

            successUser.updateMileage(successUser.getMileage() + DAILY_SUCCESS_UPDATE_MILEAGE);
        } else {
            // 주간
            // 주간 인증횟수 -> 주 n회 인증방이라면 n번쨰 인증 성공 시 50웑을 준다.

            RoomUser roomUser = certification.getRoomUser();
            List<LocalDateTime> thisWeek = statisticsService.getThisWeek();
            List<Certification> certificationList = certificationRepository.findAllByRoomUser(roomUser)
                    .orElse(new ArrayList<>());
            long count = certificationList.stream()
                    .filter(ct -> ct.getStatus() == CertificationStatus.SUCCESS
                   && ct.getCreatedTime().isAfter(thisWeek.get(0))
                   && ct.getCreatedTime().isBefore(thisWeek.get(1))
                    ).count();
            if(count == room.getFrequency()) {
                successUser.updateMileage(successUser.getMileage() + WEEKLY_SUCCESS_UPDATE_MILEAGE);
            }
        }
    }

    public void upCertificateTime(Long roomId, UserContext userContext){
        Room room = roomRepository.findById(roomId).orElseThrow(NotFoundException::new);
        User user = getUser(userContext);
        RoomUser roomUser = roomUserRepository.findByUserAndRoom(user, room).orElseThrow(NotFoundException::new);

        roomUser.setCertificateTime(roomUser.getCertificateTime() + 1);
        roomUserRepository.save(roomUser);
    }

    public void downCertificateTime(Long roomId, UserContext userContext){
        Room room = roomRepository.findById(roomId).orElseThrow(NotFoundException::new);
        User user = getUser(userContext);
        RoomUser roomUser = roomUserRepository.findByUserAndRoom(user, room).orElseThrow(NotFoundException::new);

        roomUser.setCertificateTime(roomUser.getCertificateTime() - 1);
        roomUserRepository.save(roomUser);
    }

    @Scheduled(cron = "0 0 0 * * *", zone = "Asia/Seoul")
    public void initDailyCertificateTime(){
        List<RoomUser> roomUserList = roomUserRepository.findAll().stream()
                .filter(roomUser -> roomUser.getRoom().getPeriodicity() == Periodicity.DAILY)
                .toList();
        for (RoomUser roomUser : roomUserList){
            roomUser.setCertificateTime(0);
            roomUserRepository.save(roomUser);
        }
    }

    @Scheduled(cron = "0 0 0 ? * 1", zone = "Asia/Seoul")
    public void initWeeklyCertificateTime(){
        List<RoomUser> roomUserList = roomUserRepository.findAll().stream()
                .filter(roomUser -> roomUser.getRoom().getPeriodicity() == Periodicity.WEEKLY)
                .toList();
        for (RoomUser roomUser : roomUserList){
            roomUser.setCertificateTime(0);
            roomUserRepository.save(roomUser);
        }
    }

}
