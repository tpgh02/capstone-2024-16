package com.dodo.statistics;

import com.dodo.certification.CertificationRepository;
import com.dodo.certification.domain.Certification;
import com.dodo.exception.NotFoundException;
import com.dodo.room.RoomRepository;
import com.dodo.room.domain.Room;
import com.dodo.roomuser.RoomUserRepository;
import com.dodo.roomuser.domain.RoomUser;
import com.dodo.statistics.dto.ReportResponseData;
import com.dodo.statistics.dto.SimpleReportResponseData;
import com.dodo.user.UserRepository;
import com.dodo.user.domain.User;
import com.dodo.user.domain.UserContext;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.Month;
import java.util.LinkedList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class StatisticsService {
    private final UserRepository userRepository;
    private final RoomUserRepository roomUserRepository;
    private final CertificationRepository certificationRepository;
    private final RoomRepository roomRepository;

    public ReportResponseData getReport(UserContext userContext) {
        User user = userRepository.findById(userContext.getUserId())
                .orElseThrow(() -> new NotFoundException("유저를 찾을 수 없습니다"));

        List<Float> achievementRate = achievementRate(user);

    }

    public List<Float> achievementRate(User user) {
        List<RoomUser> roomUserList = roomUserRepository.findAllByUser(user)
                .orElse(new LinkedList<RoomUser>());
        // 매일
       roomUserList.forEach(
               roomuser -> {
                   List<Certification> certificationList = certificationRepository.findAllByRoomUser(roomuser);
                   certificationList.stream()


               }
       );
        // 주 3회

        // 일 3회

    }

    public SimpleReportResponseData getSimpleReport(UserContext userContext, Long roomId) {
        User user = userRepository.findById(userContext.getUserId())
                .orElseThrow(() -> new NotFoundException("유저를 찾을 수 없습니다"));
        Room room = roomRepository.findById(roomId)
                .orElseThrow(() -> new NotFoundException("인증방을 찾을 수 없습니다"));
        RoomUser roomuser = roomUserRepository.findByUserAndRoom(user, room)
                .orElseThrow(() -> new NotFoundException("인증방에 소속되어있지 않습니다"));

        certificationRepository.findAllByRoomUser(roomuser);

        roomuser.getCreatedTime().getMonth();
        Month thisMonth = LocalDateTime.now().getMonth();
        Month lastMonth = thisMonth.minus(1);


    }

    static class MonthlyAchievementRate {
        private String month;
        private Float achievementRate;
    }
}
