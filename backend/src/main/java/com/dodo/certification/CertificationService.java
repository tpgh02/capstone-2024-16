package com.dodo.certification;

import com.dodo.certification.domain.Certification;
import com.dodo.certification.domain.CertificationStatus;
import com.dodo.image.ImageRepository;
import com.dodo.image.ImageService;
import com.dodo.image.domain.Image;
import com.dodo.room.RoomRepository;
import com.dodo.room.domain.Room;
import com.dodo.roomuser.RoomUserRepository;
import com.dodo.roomuser.domain.RoomUser;
import com.dodo.user.UserRepository;
import com.dodo.user.domain.User;
import com.dodo.user.domain.UserContext;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.UUID;

@Service
@RequiredArgsConstructor
@Slf4j
public class CertificationService {
    private final CertificationRepository certificationRepository;
    private final UserRepository userRepository;
    private final RoomRepository roomRepository;
    private final RoomUserRepository roomUserRepository;
    private final ImageService imageService;

    public void makeCertification(UserContext userContext, Long roomId, MultipartFile img) throws IOException {
//        User user = userRepository.findById(userContext.getUserId())
//                .orElseThrow(IllegalArgumentException::new);
//        Room room = roomRepository.findById(roomId)
//                .orElseThrow(IllegalArgumentException::new);
//
//        RoomUser roomUser = roomUserRepository.findByUserAndRoom(user, room)
//                        .orElseThrow(IllegalArgumentException::new);

        imageService.saveImage(img);
//        Certification.builder()
//                .status(CertificationStatus.WAIT)
//                .roomUser(roomUser);
    }

}
