package com.dodo.image;

import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.model.CannedAccessControlList;
import com.amazonaws.services.s3.model.ObjectMetadata;
import com.amazonaws.services.s3.model.PutObjectRequest;
import com.amazonaws.util.IOUtils;
import com.dodo.image.domain.Image;
import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.*;

@Service
@RequiredArgsConstructor
@Slf4j
public class ImageService {
    private final ImageRepository imageRepository;
    private final AmazonS3 amazonS3;

    private final List<String> allowedExtentionList = Arrays.asList("jpg", "jpeg", "png", "gif");
    private final String DEFAULT_IMAGE_URL = "https://my-dodo-bucket.s3.ap-northeast-2.amazonaws.com/image/default.png";

    private String bucketName;


    public Image save(MultipartFile img) throws IOException {
        if(img.isEmpty() || Objects.isNull(img.getOriginalFilename())) {
            throw new RuntimeException("이미지를 전송받지 못했습니다");
        }
        return saveImage(img);
    }

    private Image saveImage(MultipartFile img) throws IOException {
        validateImageFileExtention(img.getOriginalFilename());
        String path = uploadToS3(img);
        return imageRepository.save(new Image(path));
    }

    private String uploadToS3(MultipartFile img) throws IOException {
        String originalFilename = img.getOriginalFilename(); //원본 파일 명
        String extention = originalFilename.substring(originalFilename.lastIndexOf(".")); //확장자 명

        String s3FileName = UUID.randomUUID().toString().substring(0, 10) + originalFilename; //변경된 파일 명
        InputStream is = img.getInputStream();
        byte[] bytes = IOUtils.toByteArray(is); //image를 byte[]로 변환

        ObjectMetadata metadata = new ObjectMetadata(); //metadata 생성
        metadata.setContentType("image/" + "jpeg"); // jpeg 이면 바로보기, or extention 다른것들은 바로 다운로드 된다
        metadata.setContentLength(bytes.length);

        //S3에 요청할 때 사용할 byteInputStream 생성
        ByteArrayInputStream byteArrayInputStream = new ByteArrayInputStream(bytes);

        try{
            //S3로 putObject 할 때 사용할 요청 객체
            //생성자 : bucket 이름, 파일 명, byteInputStream, metadata
            PutObjectRequest putObjectRequest =
                    new PutObjectRequest(bucketName, s3FileName, byteArrayInputStream, metadata)
                            .withCannedAcl(CannedAccessControlList.PublicRead);

            //실제로 S3에 이미지 데이터를 넣는 부분이다.
            amazonS3.putObject(putObjectRequest); // put image to S3
        }catch (Exception e){
            throw e;
        }finally {
            byteArrayInputStream.close();
            is.close();
        }
        return amazonS3.getUrl(bucketName, s3FileName).toString();
    }

    private void validateImageFileExtention(String filename) {
        int lastDotIndex = filename.lastIndexOf(".");
        if (lastDotIndex == -1) {
            throw new RuntimeException("올바르지 못한 파일 형식입니다");
        }
        String extention = filename.substring(lastDotIndex + 1).toLowerCase();
        if (!allowedExtentionList.contains(extention)) {
            throw new RuntimeException("올바르지 못한 확장자입니다. png, jpg, jpeg, gif 만 허용합니다");
        }
    }

    @PostConstruct
    public void setBucketName() {
        bucketName = System.getenv().get("S3_BUCKET");
        imageRepository.save(new Image(DEFAULT_IMAGE_URL));
    }

}
