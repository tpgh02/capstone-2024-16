package com.dodo.room;

import com.dodo.config.auth.CustomAuthentication;
import com.dodo.exception.NotFoundException;
import com.dodo.exception.UnauthorizedException;
import com.dodo.room.domain.Category;
import com.dodo.room.domain.Room;
import com.dodo.room.domain.RoomType;
import com.dodo.room.dto.RoomData;
import com.dodo.room.dto.RoomJoinData;
import com.dodo.room.dto.RoomListData;
import com.dodo.tag.service.RoomTagService;
import com.dodo.user.domain.UserContext;
import lombok.RequiredArgsConstructor;
import com.dodo.room.domain.Room;
import com.dodo.exception.NotFoundException;
import com.dodo.roomuser.RoomUserRepository;
import com.dodo.roomuser.RoomUserService;
import com.dodo.roomuser.domain.RoomUser;
import com.dodo.tag.repository.RoomTagRepository;
import com.dodo.tag.service.RoomTagService;
import com.dodo.user.UserRepository;
import com.dodo.user.domain.User;
import com.dodo.user.domain.UserContext;
import com.dodo.user.dto.PasswordChangeRequestData;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.Collection;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

@RestController
@RequestMapping("/api/v1/room")
@RequiredArgsConstructor
@CustomAuthentication
@Slf4j
public class RoomController {

    private final RoomService roomService;
    private final RoomUserService roomUserService;
    private final RoomUserRepository roomUserRepository;
    private final RoomRepository roomRepository;
    private final UserRepository userRepository;
    private final RoomTagService roomTagService;

    @GetMapping("/list")
    public List<RoomListData> getMyRoomList(
            @RequestAttribute UserContext userContext
    ) {
        return roomService.getMyRoomList(userContext);
    }

    // 카테고리로 방 찾기
    @GetMapping("/get-rooms-by-category")
    public List<RoomData> getRoomsByCategory(@RequestParam Category category) {
        return roomService.getRoomListByCategory(category);
    }

    // 일반 인증방 생성
    @PostMapping("/create-normal-room")
    @ResponseBody
    public RoomData createNormalRoom(@RequestBody RoomData roomData, @RequestAttribute UserContext userContext){
        Room room = roomService.createRoom(roomData.getName(), roomData.getPwd(),
                roomData.getMaxUser(), roomData.getCategory(), roomData.getInfo(),
                roomData.getCertificationType(), roomData.getCanChat(),
                roomData.getNumOfVoteSuccess(), roomData.getNumOfVoteSuccess(),
                roomData.getFrequency(), roomData.getPeriodicity(), roomData.getEndDay(), RoomType.NORMAL, roomData.getCertificationTime());

        return roomService.getRoomData(roomData, userContext, room);
    }

    // ai 인증방 생성
    @PostMapping("/create-ai-room")
    @ResponseBody
    public RoomData createAIRoom(@RequestBody RoomData roomData, @RequestAttribute UserContext userContext){
        Room room = roomService.createRoom(roomData.getName(), roomData.getPwd(),
                roomData.getMaxUser(), roomData.getCategory(), roomData.getInfo(),
                roomData.getCertificationType(), roomData.getCanChat(),
                roomData.getNumOfVoteSuccess(), roomData.getNumOfVoteSuccess(),
                roomData.getFrequency(), roomData.getPeriodicity(), roomData.getEndDay(), RoomType.AI, roomData.getCertificationTime());

        return roomService.getRoomData(roomData, userContext, room);
    }

    // 그룹 인증방 생성
    @PostMapping("/create-group-room")
    @ResponseBody
    public RoomData createGroupRoom(@RequestBody RoomData roomData, @RequestAttribute UserContext userContext){
        Room room = roomService.createGroupRoom(roomData.getName(), roomData.getPwd(),
                roomData.getMaxUser(), roomData.getCategory(), roomData.getInfo(),
                roomData.getCertificationType(), roomData.getNumOfGoal(), roomData.getStringGoal(), roomData.getCanChat(),
                roomData.getNumOfVoteSuccess(), roomData.getNumOfVoteSuccess(),
                roomData.getFrequency(), roomData.getPeriodicity(), roomData.getEndDay());

        return roomService.getRoomData(roomData, userContext, room);
    }

    // 인증방 처음 입장
    @CustomAuthentication
    @PostMapping("/enter/{roomId}")
    public String roomEnter(@PathVariable Long roomId, @RequestAttribute UserContext userContext){

        if(roomUserRepository.findByUserAndRoom(
                userRepository.findById(userContext.getUserId()).orElseThrow(NotFoundException::new),
                roomRepository.findById(roomId).orElseThrow(NotFoundException::new)
        ).orElse(null) != null) {return "이미 입장한 유저입니다."; }

        roomService.plusUserCnt(roomId);
        roomUserService.createRoomUser(userContext, roomId);

        log.info("createRoomUser");
        Room room = roomRepository.findById(roomId).orElseThrow(NotFoundException::new);

        return "number of user : " + RoomData.of(room).getNowUser();
    }

    // 인증방 입장
    @GetMapping("/in/{roomId}")
    public RoomData roomIn(@PathVariable Long roomId, @RequestAttribute UserContext userContext){
        return roomService.getRoomInfo(roomId, userContext);
    }

    // 비공개 인증방 입장시 비밀번호 확인 절차
    @GetMapping("/confirmPwd/{roomId}")
    @ResponseBody
    public Boolean confirmPwd(@PathVariable Long roomId, @RequestParam String roomPwd){
        return roomService.confirmPwd(roomId, roomPwd);
    }

    // 인증방 나가기
    @CustomAuthentication
    @GetMapping("/room-out/{roomId}")
    public String roomOut(@PathVariable Long roomId, @RequestAttribute UserContext userContext){

        roomService.minusUserCnt(roomId);
        roomUserService.deleteChatRoomUser(roomId, userContext.getUserId());
        if (roomRepository.findById(roomId).orElseThrow(NotFoundException::new).getNowUser() == 0) {

            roomService.deleteRoom(roomId);
        }

        return "200 OK";
    }

    // 인증방 해체하기
    @CustomAuthentication
    @GetMapping("/delete-room/{roomId}")
    public String roomDelete(@PathVariable Long roomId, @RequestAttribute UserContext userContext) {

        if (!roomUserRepository.findByUserAndRoom(
                        userRepository.findById(userContext.getUserId()).orElseThrow(NotFoundException::new),
                        roomRepository.findById(roomId).orElseThrow(NotFoundException::new))
                .orElseThrow(NotFoundException::new).getIsManager()) {
            return "방장이 아닙니다.";
        }

        roomService.deleteRoom(roomId);

        log.info("삭제 완료");
        // 확인
        List<RoomUser> roomUserList = roomUserRepository.findAllByRoomId(roomId)
                .orElse(null);
        log.info("roomUserList null");
        if (roomUserList.isEmpty()) {
            return "인증방 해체 완료";
        }

        return "Error";
    }

    // 공지 수정하기
    @CustomAuthentication
    @PostMapping("/edit-info")
    public RoomData editInfo(@RequestBody RoomData roomData, @RequestAttribute UserContext userContext, @RequestParam String txt) {
        Room room = roomRepository.findById(roomData.getRoomId()).orElseThrow(NotFoundException::new);
        User user = userRepository.findById(userContext.getUserId()).orElseThrow(NotFoundException::new);
        RoomUser roomUser = roomUserRepository.findByUserAndRoom(user, room).orElseThrow(NotFoundException::new);

        if (!roomUser.getIsManager()) {
            throw new UnauthorizedException("권한이 없습니다");
        }

        roomService.editInfo(room.getId(), txt);

        return RoomData.of(room);
    }

    // 방장 위임하기
    @CustomAuthentication
    @PostMapping("/delegate")
    public Boolean delegate(@RequestBody RoomData roomData, @RequestParam Long userId, @RequestAttribute UserContext userContext){
        Room room = roomRepository.findById(roomData.getRoomId()).orElseThrow(NotFoundException::new);
        User manager = userRepository.findById(userContext.getUserId()).orElseThrow(NotFoundException::new);
        User user = userRepository.findById(userId).orElseThrow(NotFoundException::new);

        roomService.delegate(room, manager, user);

        return roomUserRepository.findByUserAndRoom(user, room).orElseThrow(NotFoundException::new).getIsManager();
    }

    // 목표 날짜가 돼서 인증방 해체
    @Scheduled(cron = "0 0 0 * * *", zone = "Asia/Seoul")
    @GetMapping("/room-expired")
    public void expired() {
        roomService.expired();
    }

    // 방장의 인증방 설정 수정
    @CustomAuthentication
    @PostMapping("/update")
    @ResponseBody
    public RoomData update(@RequestBody RoomData roomData,
                           @RequestAttribute UserContext userContext,
                           @RequestParam Long roomId){
        roomService.update(roomId, userContext, roomData);

        return RoomData.of(roomRepository.findById(roomId).orElseThrow(NotFoundException::new));
    }

    // 인증방 이미지 변경
    @CustomAuthentication
    @PostMapping("/change-image")
    @ResponseBody
    public RoomData changeImage(@RequestParam(required = false) Long roomId,
                                @RequestParam MultipartFile image) throws IOException {

        return roomService.changeRoomImage(roomId, image);

    }

    // 유저 추방
    @CustomAuthentication
    @PostMapping("/repel")
    public String repel(@RequestParam Long roomId, @RequestAttribute UserContext userContext, @RequestParam Long userId) {
        roomService.repel(roomId, userContext, userId);

        return "OK";

    }

    // 인증방 제목으로 검색
    @GetMapping("/search-room")
    @ResponseBody
    public List<RoomData> getRoomListByNameAndTag(@RequestParam String string) {
        List<RoomData> roomListByName = roomService.getRoomListByName(string);
        List<RoomData> roomListByTag = roomTagService.getRoomListByTag(string);
        try {
            List<RoomData> roomListById = roomService.getRoomListById(Long.parseLong(string));

            return Stream.of(roomListByName, roomListByTag, roomListById)
                    .flatMap(Collection::stream)
                    .sorted(Comparator.comparing(RoomData::getIsFull).reversed()
                            .thenComparing(RoomData::getNowUser).reversed())
                    .distinct()
                    .collect(Collectors.toList());

        } catch (NumberFormatException e) {

            return Stream.of(roomListByName, roomListByTag)
                    .flatMap(Collection::stream)
                    .sorted(Comparator.comparing(RoomData::getIsFull).reversed()
                            .thenComparing(RoomData::getNowUser).reversed())
                    .distinct()
                    .collect(Collectors.toList());
        }
    }

    @GetMapping("/room-detail-to-join")
    @ResponseBody
    public RoomJoinData getRoomDetailToJoin(@RequestParam Long roomId, @RequestAttribute UserContext userContext) {
        return roomService.getRoomDetatil(roomId, userContext);
    }

    // 그룹인증방의 마일스톤 넘기기
    @PostMapping("/up-milestone/{roomId}")
    public String upMilestone(@PathVariable Long roomId){
        roomService.upMilestone(roomId);

        return "200 OK";
    }

}
