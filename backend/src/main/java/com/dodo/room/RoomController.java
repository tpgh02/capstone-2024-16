package com.dodo.room;

import com.dodo.config.auth.CustomAuthentication;
import com.dodo.room.dto.RoomData;
import com.dodo.room.dto.UserData;
import com.dodo.user.domain.UserContext;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/room")
@RequiredArgsConstructor
@CustomAuthentication
public class RoomController {

    private final RoomService roomService;

    @GetMapping("/list")
    public List<RoomData> getMyRoomList(
            @RequestAttribute UserContext userContext
    ) {
        return roomService.getMyRoomList(userContext);
    }


    // TODO
    // UserData 라는 이름으로 괜찮을지,,
    @GetMapping("/users")
    public List<UserData> getUsersInTheRoom(
            @RequestAttribute UserContext userContext,
            @RequestParam Long roomId) {
        return roomService.getUsers(userContext, roomId);
    }
}
