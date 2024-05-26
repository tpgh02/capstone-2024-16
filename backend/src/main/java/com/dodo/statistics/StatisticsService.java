package com.dodo.statistics;

import com.dodo.certification.CertificationRepository;
import com.dodo.certification.domain.Certification;
import com.dodo.certification.domain.CertificationStatus;
import com.dodo.exception.NotFoundException;
import com.dodo.room.RoomRepository;
import com.dodo.room.domain.Category;
import com.dodo.room.domain.Periodicity;
import com.dodo.room.domain.Room;
import com.dodo.roomuser.RoomUserRepository;
import com.dodo.roomuser.domain.RoomUser;
import com.dodo.statistics.dto.*;
import com.dodo.user.UserRepository;
import com.dodo.user.domain.User;
import com.dodo.user.domain.UserContext;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.time.*;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class StatisticsService {
    private final UserRepository userRepository;
    private final RoomUserRepository roomUserRepository;
    private final CertificationRepository certificationRepository;
    private final RoomRepository roomRepository;

    public ReportResponseData getReport(UserContext userContext) {
        User user = userRepository.findById(userContext.getUserId())
                .orElseThrow(() -> new NotFoundException("유저를 찾을 수 없습니다"));
        List<RoomUser> roomUserList = roomUserRepository.findAllByUser(user)
                .orElse(new ArrayList<>());


        // 이번달 저번달 달성률
        float roomUserSize = (float) roomUserList.size();
        float lastMonth = 0F;
        float thisMonth = 0F;

        for(RoomUser roomuser : roomUserList) {
            Room room = roomuser.getRoom();
            SimpleReportResponseData data = getSimpleReport(userContext, room.getId());
            lastMonth += data.getLastMonth();
            thisMonth += data.getThisMonth();
        }

        // 가장 열심히 한 분야
        List<Certification> certificationList = certificationRepository.findAllByRoomUserIn(roomUserList)
                .orElse(new ArrayList<>());
        Integer allCategoryStatus = certificationList.size();
        Map<Category, Long> categoryStatus = certificationList.stream()
                .collect(Collectors.groupingBy(c -> c.getRoomUser().getRoom().getCategory(), Collectors.counting()));


        // 가장 많이 활동한 방에서 나는?
        RoomUser maxRoomUser = roomUserRepository.findAllByUser(user)
                .orElse(new ArrayList<>())
                .stream()
                .max((ru1, ru2) -> (int) (certificationRepository.countAllByRoomUser(ru1) - certificationRepository.countAllByRoomUser(ru2)))
                .get();

        //TODO findAllByRoomUserRoom 이거 작동 하나..?
        Map<User, Long> CertificationListFromUser = certificationRepository.findAllByRoomUserRoom(maxRoomUser.getRoom())
                .orElse(new ArrayList<>())
                .stream()
                .collect(Collectors.groupingBy(c -> c.getRoomUser().getUser(), Collectors.counting()));

        List<User> keys = new ArrayList<>(CertificationListFromUser.keySet());

        keys.sort(Comparator.comparing(CertificationListFromUser::get));
        Float mostActivity = (float) keys.indexOf(maxRoomUser.getUser()) / (float) keys.size();

        return new ReportResponseData(lastMonth / roomUserSize, thisMonth / roomUserSize, categoryStatus, allCategoryStatus, mostActivity);
    }

    @Transactional
    public SimpleReportResponseData getSimpleReport(UserContext userContext, Long roomId) {
        User user = userRepository.findById(userContext.getUserId())
                .orElseThrow(() -> new NotFoundException("유저를 찾을 수 없습니다"));
        Room room = roomRepository.findById(roomId)
                .orElseThrow(() -> new NotFoundException("인증방을 찾을 수 없습니다"));
        RoomUser roomuser = roomUserRepository.findByUserAndRoom(user, room)
                .orElseThrow(() -> new NotFoundException("인증방에 소속되어있지 않습니다"));

        List<Certification> certificationList = certificationRepository.findAllByRoomUser(roomuser)
                .orElse(new ArrayList<>());
        log.info("{}", roomuser);
        log.info("size = {}", certificationList.size());
        List<DailyGoalResponseData> calender = getEmptyMonth();
        LocalDateTime now = LocalDateTime.now();

        if(room.getPeriodicity() == Periodicity.DAILY) {
            // 일일 인증

            // 지난 달
            LocalDateTime lastStart = YearMonth.now().minusMonths(1).atDay(1).atTime(LocalTime.MIN);
            LocalDateTime lastEnd = YearMonth.now().minusMonths(1).atEndOfMonth().atTime(LocalTime.MAX);
            long lastMonthCount = getCertificationSuccessCount(certificationList, lastStart, lastEnd);
            long lastMonthSize = lastEnd.getDayOfMonth();

            // 이번 달
            LocalDateTime start = YearMonth.now().atDay(1).atTime(LocalTime.MIN);
            LocalDateTime end = YearMonth.now().atDay(now.getDayOfMonth()).atTime(LocalTime.MAX);
            long thisMonthCount = getCertificationSuccessCount(certificationList, start, end);
            long thisMonthSize = lastEnd.getDayOfMonth();
            getCalender(certificationList, calender, start, end);

            return new SimpleReportResponseData(calender, lastMonthCount, lastMonthSize, thisMonthCount, thisMonthSize);
        } else {
            // 주간 인증

            long frequency = room.getFrequency();

            long lastMonthCount = 0;
            long lastMonthSize = 0;
            LocalDateTime start = YearMonth.now().minusMonths(1).atEndOfMonth().atTime(LocalTime.MIN);
            if(start.getDayOfWeek().getValue() != 1) {
                start = start.plusDays(8 - start.getDayOfWeek().getValue());
            }
            while(true) {
                LocalDateTime end = start.plusDays(6).with(LocalDate.MAX);
                if(end.getMonth().equals(now.getMonth())) break;
                lastMonthCount += getCertificationSuccessCount(certificationList, start, end);
                lastMonthCount += frequency;
                start = start.plusDays(7);
            }

            // 이번 달

            long thisMonthCount = 0;
            long thisMonthSize = 0;
            while(true) {
                LocalDateTime end = start.plusDays(6).with(LocalDate.MAX);
                if(end.isAfter(now)) break;
                thisMonthCount += getCertificationSuccessCount(certificationList, start, end);
                thisMonthCount += frequency;
                start = start.plusDays(7);
            }

            LocalDateTime monthStart = YearMonth.now().atDay(1).atTime(LocalTime.MIN);
            LocalDateTime monthEnd = YearMonth.now().atDay(now.getDayOfMonth()).atTime(LocalTime.MAX);
            getCalender(certificationList, calender, monthStart, monthEnd);
            return new SimpleReportResponseData(calender, lastMonthCount, lastMonthSize, thisMonthCount, thisMonthSize);
        }
    }

    private long getCertificationSuccessCount(List<Certification> certificationList, LocalDateTime start, LocalDateTime end) {
        return certificationList.stream()
                .filter(certification -> {
                    if(certification.getStatus() == CertificationStatus.SUCCESS) {
                        LocalDateTime time = certification.getCreatedTime();
                        return time.isAfter(start) && time.isBefore(end);
                    }
                    return false;
                }).count();
    }

    private void getCalender(List<Certification> certificationList, List<DailyGoalResponseData> calender, LocalDateTime start, LocalDateTime end) {
        certificationList
                .forEach(certification -> {
                    if(certification.getStatus() == CertificationStatus.SUCCESS) {
                        LocalDateTime time = certification.getCreatedTime();
                        if(time.isAfter(start) && time.isBefore(end)) {
                            calender.get(time.getDayOfMonth() - 1).setFlag(true);
                        }
                    }
                });
    }


    // TODO
    // 테스트 필요함
    public List<DailyGoalResponseData> getWeeklyGoal(UserContext userContext) {
        User user = userRepository.findById(userContext.getUserId())
                .orElseThrow(() -> new NotFoundException("유저를 찾을 수 없습니다"));
        List<RoomUser> roomUser = roomUserRepository.findAllByUser(user)
                .orElse(new ArrayList<>());
        List<Certification> certificationList = certificationRepository.findAllByRoomUserIn(roomUser)
                .orElse(new ArrayList<>());
        List<LocalDateTime> thisWeek = getThisWeek();
        log.info("start = {}", thisWeek.get(0));
        List<DailyGoalResponseData> result = getEmptyWeek(thisWeek.get(0));

        certificationList.stream()
                // 인증 기록중에 이번주 필터
                .filter(certification -> {
                    LocalDateTime time = certification.getCreatedTime();
                    return time.isAfter(thisWeek.get(0)) && time.isBefore(getThisWeek().get(1));
                })
                .forEach(
                        certification -> {
                            if(certification.getStatus() == CertificationStatus.SUCCESS) {
                                result.get(certification.getCreatedTime().getDayOfWeek().getValue() - 1).setFlag(true);
                            }
                        }
                );
        return result;
    }


    // 이번주의 시작과 끝을 반환
    public RoomProfileData getRoomProfile(UserContext userContext, Long roomUserId) {
        RoomUser roomUser = roomUserRepository.findById(roomUserId)
                .orElseThrow(() -> new NotFoundException("회원을 찾을 수 없습니다"));


        String since = roomUser.getCreatedTime().format(DateTimeFormatter.ofPattern("yyyy. MM. dd."));
        List<Certification> certificationList = certificationRepository.findAllByRoomUser(roomUser)
                .orElse(new ArrayList<Certification>());

        List<LocalDateTime> thisWeek = getThisWeek();
        Long latelySuccess = certificationList.stream()
                // 인증 기록중에 이번주 필터
                .filter(certification -> {
                    LocalDateTime time = certification.getCreatedTime();
                    return certification.getStatus() == CertificationStatus.SUCCESS &&
                            time.isAfter(thisWeek.get(0)) &&
                            time.isBefore(getThisWeek().get(1));
                }).count();

        return RoomProfileData.builder()
                .roomUserId(roomUserId)
                .userName(roomUser.getUser().getName())
                .since(since)
                .image(roomUser.getUser().getImage())
                .success((long) certificationList.size())
                .allSuccess(ChronoUnit.DAYS.between(roomUser.getCreatedTime(), LocalDateTime.now()))
                .lately(latelySuccess)
                .allLately(7L)
                .build();

    }

    // TODO
    public List<AlbumResponseData> getAlbum(UserContext userContext) {
        User user = userRepository.findById(userContext.getUserId())
                .orElseThrow(() -> new NotFoundException("유저를 찾을 수 없습니다"));
        List<RoomUser> roomUserList = roomUserRepository.findAllByUser(user)
                .orElse(new ArrayList<>());
        return certificationRepository.findAllByRoomUserIn(roomUserList)
                .orElse(new ArrayList<>())
                .stream()
                .map(AlbumResponseData::new)
                .toList();
    }

    public List<LocalDateTime> getThisWeek() {
        LocalDateTime now = LocalDateTime.now();
        DayOfWeek dayOfWeek = now.getDayOfWeek();
        LocalDateTime sunday = now.plusDays(7 - dayOfWeek.getValue()).with(LocalTime.MAX);
        LocalDateTime monday = sunday.minusDays(6).with(LocalTime.MIN);
        return Arrays.asList(monday, sunday);
    }
    private List<DailyGoalResponseData> getEmptyWeek(LocalDateTime thisWeekStart) {
        List<DailyGoalResponseData> result = new ArrayList<>();
        // flag false 인 일주일 만들기
        for(int i = 0; i < 7; i++) {
            result.add(new DailyGoalResponseData(thisWeekStart.plusDays(i)));
        }
        return result;
    }

    private List<DailyGoalResponseData> getEmptyMonth() {
        YearMonth now = YearMonth.now();
        List<DailyGoalResponseData> result = new ArrayList<>();
        // flag false 인 일주일 만들기
        for(int i = 1; i <= now.atEndOfMonth().getDayOfMonth(); i++) {
            result.add(new DailyGoalResponseData(i));
        }
        return result;
    }
}
