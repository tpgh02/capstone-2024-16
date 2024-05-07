import 'package:dodo/const/colors.dart';
import 'package:dodo/const/server.dart';
// import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

class c_dialog extends StatefulWidget {
  final int room_id;
  const c_dialog(this.room_id);

  @override
  State<c_dialog> createState() => _c_dialogState();
}

class _c_dialogState extends State<c_dialog> {
  final ImagePicker _picker = ImagePicker();
  final List<File?> _pickedImages = [];

  void getImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        _pickedImages.add(File(image.path));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const TextStyle style =
        TextStyle(color: Colors.white, fontFamily: "kcc", fontSize: 30);
    int c_length = 3; //인증개수

    return Dialog(
      child: SizedBox(
        height: 500,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "오늘의 도전을\n아직 완료하지 않았어요",
                    style: TextStyle(fontFamily: 'bm', fontSize: 25),
                  ),
                  IconButton(
                    onPressed: () async {
                      await patchUserProfileImage(_pickedImages);

                      //팝업 지우기
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.close,
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
                child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  Column(
                    children: List.generate(c_length, (index) {
                      return select(index);
                    }),
                  ),
                ],
              ),
            )),
            const SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
    );
  }

// var url = serverUrl + '/api/v1/certification/upload';

  Future<dynamic> patchUserProfileImage(List<File?> pickedImages) async {
    print("프로필 사진을 서버에 업로드 합니다.");
    var dio = Dio();
    var url = serverUrl + '/api/v1/certification/upload';

    final List<MultipartFile> _files = pickedImages.map((img) {
      if (img != null) {
        return MultipartFile.fromFileSync(
          img.path,
          contentType: MediaType("image", "jpg"),
        );
      } else {
        throw Exception('이미지 파일이 유효하지 않습니다.');
      }
    }).toList();

    try {
      dio.options.contentType = 'multipart/form-data';
      dio.options.maxRedirects.isFinite;

      FormData formData = FormData.fromMap({
        "certificationId": 1,
        "image": _files,
      });

      dio.options.headers = {
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjF9.8PJk4wE2HsDlgLmFA_4PU2Ckb7TWmXfG0Hfz2pRE9WU'
      };

      final response = await dio.post(url, data: formData);

      if (response.statusCode == 200) {
        // final responseData = response.data;
        // final imageUrl = responseData["image"]["url"];
        print('성공적으로 업로드했습니다');
        //return imageUrl;
      } else {
        print('서버로부터 잘못된 응답이 도착했습니다. 상태 코드: ${response.statusCode}');
        //return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

//사진 고르는 부분
  Widget select(int index) {
    return Container(
      width: 180,
      height: 180,
      margin: EdgeInsets.symmetric(vertical: 10), // 각 컨테이너 사이에 간격 추가
      child: InkWell(
        onTap: () {
          getImage(ImageSource.gallery);
        },
        child: Stack(
          children: [
            if (_pickedImages.length > index && _pickedImages[index] != null)
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: DARKGREY,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    File(_pickedImages[index]!.path),
                    fit: BoxFit.cover,
                  ),
                ),
              )
            else
              Container(
                alignment: Alignment.center,
                child: const Icon(
                  Icons.camera_alt,
                  color: PRIMARY_COLOR,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
