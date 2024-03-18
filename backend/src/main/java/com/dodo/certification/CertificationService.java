package com.dodo.certification;

import com.dodo.certification.domain.Certification;
import com.dodo.certification.domain.CertificationStatus;
import com.dodo.certification.dto.CertificationResponseData;
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
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

@Service
@RequiredArgsConstructor
@Slf4j
public class CertificationService {

    private final CertificationRepository certificationRepository;
    private final UserRepository userRepository;
    private final RoomRepository roomRepository;
    private final RoomUserRepository roomUserRepository;
    private final ImageService imageService;

    public CertificationResponseData makeCertification(UserContext userContext, Long roomId, MultipartFile img) throws IOException {
        User user = userRepository.findById(userContext.getUserId())
                .orElseThrow(NotFoundException::new);
        Room room = roomRepository.findById(roomId)
                .orElseThrow(NotFoundException::new);

        RoomUser roomUser = roomUserRepository.findByUserAndRoom(user, room)
                        .orElseThrow(NotFoundException::new);

        Image image = imageService.saveImage(img);

        Certification.builder()
                .status(CertificationStatus.WAIT)
                .roomUser(roomUser)
                .image(image);
        return new CertificationResponseData();
    }

    public void voting(UserContext userContext, Long certificationId) {


    }

    public void approval(UserContext userContext, Long certificationId) {

    }
}
