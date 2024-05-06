package com.dodo.room;

import com.dodo.exception.NotFoundException;
import com.dodo.room.domain.*;
import com.dodo.room.dto.RoomData;
import com.dodo.room.dto.RoomListData;
import com.dodo.room.dto.UserData;
import com.dodo.roomuser.RoomUserRepository;
import com.dodo.roomuser.RoomUserService;
import com.dodo.roomuser.domain.RoomUser;
import com.dodo.tag.domain.RoomTag;
import com.dodo.tag.domain.Tag;
import com.dodo.tag.repository.RoomTagRepository;
import com.dodo.tag.service.RoomTagService;
import com.dodo.user.PasswordAuthenticationRepository;
import com.dodo.user.UserRepository;
import com.dodo.user.domain.PasswordAuthentication;
import com.dodo.user.domain.User;
import com.dodo.user.domain.UserContext;
import com.dodo.user.dto.PasswordChangeRequestData;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Comparator;
import java.util.List;

import static com.dodo.room.dto.RoomListData.updateStatus;

@Service
@RequiredArgsConstructor
@Slf4j
public class RoomService {

    private final UserRepository userRepository;
    private final RoomUserRepository roomUserRepository;
    private final RoomRepository roomRepository;
    private final RoomUserService roomUserService;
    private final RoomTagRepository roomTagRepository;
    private final RoomTagService roomTagService;
    private final PasswordAuthenticationRepository passwordAuthenticationRepository;

    public List<RoomListData> getMyRoomList(UserContext userContext) {
        User user = getUser(userContext);

        return roomUserRepository.findAllByUser(user)
                .orElseThrow(NotFoundException::new)
                .stream()
                .map(RoomUser::getRoom)
                .map(RoomListData::new)
                .map(RoomListData -> updateStatus(RoomListData, roomUserService.getCertificationStatus(userContext, RoomListData)))
                .toList();
    }

    public List<UserData> getUsers(UserContext userContext, Long roomId) {
        return roomUserRepository.findAllByRoomId(roomId)
                .orElseThrow(NotFoundException::new)
                .stream()
                .map(UserData::new) //TODO
                .toList();
    }

    public List<RoomData> getRoomListByCategory(Category category) {
        return roomRepository.findAllByCategory(category)
                .orElseThrow(NotFoundException::new)
                .stream()
                .map(RoomData::of)
                .sorted(Comparator.comparing(RoomData::getIsFull).reversed()
                        .thenComparing(RoomData::getNowUser).reversed())
                .toList();

    }

    // 인증방 제목으로 검색
    public List<RoomData> getRoomListByName(String name){
        return roomRepository.findAllByNameContaining(name).orElseThrow(NotFoundException::new)
                .stream()
                .map(RoomData::of)
                .toList();
    }

    // 인증방 아이디로 검색
    public List<RoomData> getRoomListById(Long roomId){
        return roomRepository.findAllById(roomId).orElseThrow(NotFoundException::new)
                .stream()
                .map(RoomData::of)
                .toList();
    }

    // 인증방 생성
    public Room createRoom(String roomName, String roomPwd, Long maxUser, Category category,
                                 String info, CertificationType certificationType,
                                 Boolean canChat, Integer numOfVoteSuccess, Integer numOfVoteFail,
                                 Integer frequency, Periodicity periodicity, LocalDateTime endDate, RoomType roomType){
        Boolean isFull = maxUser == 1;
        Room room = Room.builder()
                .name(roomName)
                .password(roomPwd)
                .maxUser(maxUser)
                .nowUser(1L)
                .category(category)
                .info(info)
                .certificationType(certificationType)
                .periodicity(periodicity)
                .canChat(canChat)
                .endDay(endDate)
                .frequency(frequency)
                .numOfVoteSuccess(numOfVoteSuccess).numOfVoteFail(numOfVoteFail)
                .roomType(roomType)
                .isFull(isFull)
                .build();

        roomRepository.save(room);
        return room;
    }

    // 그룹 인증방 생성
    public Room createGroupRoom(String roomName, String roomPwd, Long maxUser, Category category,
                                 String info, CertificationType certificationType, Integer numOfGoal, List<String> goal,
                                 Boolean canChat, Integer numOfVoteSuccess, Integer numOfVoteFail,
                                 Integer frequency, Periodicity periodicity, LocalDateTime endDate){
        Boolean isFull = maxUser == 1;
        Room room = Room.builder()
                .name(roomName)
                .password(roomPwd)
                .maxUser(maxUser)
                .nowUser(1L)
                .category(category)
                .info(info)
                .certificationType(certificationType)
                .periodicity(periodicity)
                .canChat(canChat)
                .endDay(endDate)
                .frequency(frequency)
                .numOfVoteSuccess(numOfVoteSuccess).numOfVoteFail(numOfVoteFail)
                .roomType(RoomType.GROUP)
                .numOfGoal(numOfGoal)
                .goal(goal)
                .isFull(isFull)
                .build();

        roomRepository.save(room);
        return room;
    }

    // 인증방 비밀번호 조회
    public Boolean confirmPwd(Long roomId, String roomPwd){
        return roomPwd.equals(roomRepository.findById(roomId).orElseThrow(NotFoundException::new).getPassword());
    }

    // 채팅방 인원 증가
    public void plusUserCnt(Long roomId){
        log.info("plus room Id : {}", roomId);
        Room room = roomRepository.findById(roomId).orElseThrow(NotFoundException::new);
        room.setNowUser(room.getNowUser()+1);
    }

    // 채팅방 인원 감소
    public void minusUserCnt(Long roomId){
        log.info("room Id : {}", roomId);
        Room room = roomRepository.findById(roomId).orElseThrow(NotFoundException::new);
        room.setNowUser(room.getNowUser()-1);
    }

    // 채팅방 삭제
    public void deleteRoom(Long roomId){
        Room room = roomRepository.findById(roomId).
                orElse(null);
        if (room == null){
            System.out.println("room = null");
            return;
        }
        roomRepository.deleteById(roomId);
    }

    // 채팅방 공지 수정
    public void editInfo(Long roomId, String txt){
        Room room = roomRepository.findById(roomId).orElseThrow(NotFoundException::new);
        room.setInfo(txt);
        roomRepository.save(room);
    }

    // 방장 권한 위임
    public void delegate(Room room, User manager, User user){
        RoomUser roomManager = roomUserRepository.findByUserAndRoom(manager, room).orElseThrow(NotFoundException::new);
        RoomUser roomUser = roomUserRepository.findByUserAndRoom(user, room).orElseThrow(NotFoundException::new);

        roomManager.setIsManager(false);
        roomUser.setIsManager(true);

        roomUserRepository.save(roomManager);
        roomUserRepository.save(roomUser);
    }

    // 목표 날짜가 돼서 인증방 해체
    public void expired(){
        List<Room> roomList = roomRepository.findAll();

        for (Room room : roomList){

            if (room.getEndDay().toLocalDate().isEqual(LocalDate.now(ZoneId.of("Asia/Seoul")))){

                roomUserRepository.findAllByRoomId(room.getId()).orElseThrow(NotFoundException::new).
                        forEach(roomUser -> roomUserService.deleteChatRoomUser(roomUser.getRoom().getId(), roomUser.getUser().getId()));
                deleteRoom(room.getId());
            }

        }
    }

    // 방장의 채팅방 설정 수정
    public void update(Long roomId, UserContext userContext, RoomData roomData) {
        User user = userRepository.findById(userContext.getUserId()).orElseThrow(NotFoundException::new);
        Room room = roomRepository.findById(roomId).orElseThrow(NotFoundException::new);
        RoomUser roomUser = roomUserRepository.findByUserAndRoom(user, room).orElseThrow(NotFoundException::new);
        List<RoomTag> roomTags = roomTagRepository.findAllByRoom(room).orElseThrow(NotFoundException::new);

        if (!roomUser.getIsManager()) {
            log.info("you are not manager");
        }
        else {
            log.info("roomData's maxUser : {}", roomData.getMaxUser());
            room.update(
                    roomData.getName(),
                    roomData.getInfo(),
                    roomData.getEndDay(),
                    roomData.getMaxUser(),
                    roomData.getCanChat(),
                    roomData.getNumOfVoteSuccess(),
                    roomData.getNumOfVoteFail(),
                    roomData.getImage(),
                    roomData.getPeriodicity(),
                    roomData.getFrequency(),
                    roomData.getCertificationType()
            );
            roomTagRepository.deleteAllInBatch(roomTags);
            roomTagService.saveRoomTag(room, roomData.getTag());

            log.info("room name : {}", room.getName());
        }
    }

    // 인증방 비밀번호 변경
    @Transactional
    public boolean changeRoomPassword(Long roomId, PasswordChangeRequestData passwordChangeRequestData) {

        Room room = roomRepository.findById(roomId).orElseThrow(NotFoundException::new);

        String password = room.getPassword();

        if(!password.equals(passwordChangeRequestData.getCurrentPassword())) {
            throw new RuntimeException("현재 비밀번호가 일치하지 않습니다.");
        }
        if(!passwordChangeRequestData.getChangePassword1().equals(passwordChangeRequestData.getChangePassword2())) {
            throw new RuntimeException("새로운 비밀번호 1, 2가 일치하지 않습니다.");
        }
        if(passwordChangeRequestData.getCurrentPassword().equals(passwordChangeRequestData.getChangePassword1())) {
            throw new RuntimeException("현재 비밀번호와 새로운 비밀번호가 일치합니다.");
        }
        room.updatePwd(passwordChangeRequestData.getChangePassword1());

        return true;
    }

    // 유저 추방
    public void repel(Long roomId, UserContext userContext, Long userId){
        Room room = roomRepository.findById(roomId).orElseThrow(NotFoundException::new);
        User manager = userRepository.findById(userContext.getUserId()).orElseThrow(NotFoundException::new);
        RoomUser roomManager = roomUserRepository.findByUserAndRoom(manager, room).orElseThrow(NotFoundException::new);

        if (!roomManager.getIsManager()) {
            log.info("not manager");
        } else {
            roomUserService.deleteChatRoomUser(roomId, userContext.getUserId());
            minusUserCnt(roomId);
        }

    }

    public RoomData getRoomInfo(Long roomId){
        Room room = roomRepository.findById(roomId).orElseThrow(NotFoundException::new);
        RoomData roomData = RoomData.of(room);
        List<RoomTag> roomTag = roomTagRepository.findAllByRoom(room).orElseThrow(NotFoundException::new);
        List<String> tags = roomTag.stream()
                .map(RoomTag::getTag)
                .map(Tag::getName)
                .toList();
        roomData.updateTag(tags);
        return roomData;
    }

    public User getUser(UserContext userContext) {
        return userRepository.findById(userContext.getUserId()).orElseThrow(NotFoundException::new);
    }

}
