import 'dart:io';
import 'dart:developer';
import 'package:dodo/components/room_group.dart';
import 'package:dodo/components/room_main.dart';
import 'package:dodo/const/colors.dart';
import 'package:dodo/const/server.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

// 인증방 이미지 변경
Future<dynamic> fetchRoomImage(File? pickedImage, int roomId) async {
  var dio = Dio();
  var editImageUrl = '$serverUrl/api/v1/room/change-image';
  MultipartFile toEditImage;
  if (pickedImage != null) {
    toEditImage = MultipartFile.fromFileSync(
      pickedImage.path,
      contentType: MediaType("image", "jpg"),
    );
  } else {
    throw Exception('이미지 파일이 유효하지 않습니다.');
  }

  FormData formData =
      FormData.fromMap({'image': toEditImage, 'roomId': roomId});

  try {
    dio.options.contentType = 'multipart/form-data';
    dio.options.maxRedirects.isFinite;

    dio.options.headers = {
      'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjF9.8PJk4wE2HsDlgLmFA_4PU2Ckb7TWmXfG0Hfz2pRE9WU',
    };

    final imageEditResponse = await dio.post(editImageUrl,
        data: formData, options: Options(contentType: 'multipart/form-data'));

    if (imageEditResponse.statusCode == 200) {
      log('커버 이미지 변경 성공: $imageEditResponse');
    } else {
      log('서버로부터 잘못된 응답이 도착했습니다. 상태 코드: ${imageEditResponse.statusCode}');
    }
  } catch (e) {
    print(e);
    return null;
  }
}

Future<dynamic> fetchBasicImage(int roomId) async {
  var dio = Dio();
  var editImageUrl = '$serverUrl/api/v1/room/change-image';

  FormData formData = FormData.fromMap({
    'image':
        'https://my-dodo-bucket.s3.ap-northeast-2.amazonaws.com/image/default.png',
    'roomId': roomId
  });

  try {
    log("step 1");

    dio.options.contentType = 'multipart/form-data';
    dio.options.maxRedirects.isFinite;

    dio.options.headers = {
      'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjF9.8PJk4wE2HsDlgLmFA_4PU2Ckb7TWmXfG0Hfz2pRE9WU',
    };

    log("step 2");
    final imageEditResponse = await dio.post(editImageUrl,
        data: formData, options: Options(contentType: 'multipart/form-data'));

    log("step 3");
    if (imageEditResponse.statusCode == 200) {
      log('커버 이미지 삭제 성공: $imageEditResponse');
    } else {
      log('서버로부터 잘못된 응답이 도착했습니다. 상태 코드: ${imageEditResponse.statusCode}');
    }
  } catch (e) {
    print(e);
    return null;
  }
}

class room_list extends StatefulWidget {
  final String room_title;
  final int room_id;
  final String? room_pwd;
  final String room_type;
  final room_img;
  final int room_mem;
  final int room_maxmem;
  final String? status;
  final bool is_manager;
  final String certificationType;
  const room_list({
    super.key,
    required this.room_title,
    required this.room_id,
    this.room_pwd,
    required this.room_type,
    required this.room_img,
    required this.room_mem,
    required this.room_maxmem,
    required this.status,
    required this.is_manager,
    required this.certificationType,
  });

  @override
  State<room_list> createState() => _roomListState();
}

class _roomListState extends State<room_list> {
  final ImagePicker _picker = ImagePicker();
  late File? _pickedImage = File('assets/images/turtle_noradius.png');

  void getNewImage(ImageSource source) async {
    final XFile? selectedImage = await _picker.pickImage(source: source);
    if (selectedImage != null) {
      setState(() {
        _pickedImage = File(selectedImage.path);
      });
      log("이미지 선택함: $_pickedImage");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 15, 10),
          child: SizedBox(
            height: 90,
            child: Row(
              children: [
                // 인증방 썸네일 이미지
                GestureDetector(
                  onTap: () {
                    widget.is_manager
                        ? editCoverDialog(widget.room_img['url'].toString())
                        : null;
                  },
                  child: SizedBox(
                    width: 90,
                    height: 90,
                    child: ClipOval(
                      child: Image.network(
                        widget.room_img['url'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                // 방 제목 및 속성
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            if (widget.room_type != "GROUP") {
                              return room_main(
                                room_id: widget.room_id,
                                status: widget.status,
                              );
                            } else {
                              return room_group(
                                room_id: widget.room_id,
                                status: widget.status,
                              );
                            }
                          },
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // 방 이름
                        Text(
                          widget.room_title,
                          style: const TextStyle(
                            fontFamily: "bm",
                            fontSize: 21,
                          ),
                        ),
                        // 방 속성
                        Row(
                          children: [
                            // 인원 수
                            const Icon(Icons.person),
                            Text(' ${widget.room_mem}/${widget.room_maxmem}'),

                            // 인증방 타입
                            widget.room_type == "GROUP"
                                ? const Padding(
                                    padding: EdgeInsets.fromLTRB(6, 0, 0, 0),
                                    child: Icon(
                                      Icons.groups_3,
                                      size: 30,
                                    ),
                                  )
                                : const SizedBox(
                                    width: 0.1,
                                  ),

                            widget.room_type == "AI"
                                ? Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(6, 0, 0, 0),
                                    child: SizedBox(
                                      height: 30,
                                      width: 30,
                                      child: Image.asset(
                                          'assets/images/AIMark.png'),
                                    ),
                                  )
                                : const SizedBox(
                                    width: 0.1,
                                  ),

                            // 비밀방 여부
                            widget.room_pwd == null || widget.room_pwd == ""
                                ? const SizedBox(
                                    width: 0.1,
                                  )
                                : const Padding(
                                    padding: EdgeInsets.fromLTRB(6, 0, 0, 0),
                                    child: Icon(
                                      Icons.lock,
                                      size: 23,
                                    ),
                                  ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // 도장
                widget.status == "FAIL" || widget.status == "WAIT"
                    ? Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: const Color.fromARGB(0, 0, 0, 0),
                              width: 1.5),
                        ),
                        width: 70,
                        height: 90,
                      )
                    : const SizedBox(
                        width: 70,
                        height: 90,
                        child: Icon(
                          Icons.check_box_rounded,
                          size: 60,
                          color: PRIMARY_COLOR,
                        ))
              ],
            ),
          ),
        ),
        const Divider(color: Colors.black38),
      ],
    );
  }

  // 그룹 이미지 수정 팝업
  Widget editRoomImg() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      height: 180,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              '프로필 사진을 선택해주세요.',
              style: TextStyle(
                color: POINT_COLOR,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                TextButton(
                  onPressed: () async {
                    getNewImage(ImageSource.gallery);
                    Navigator.of(context).pop();
                  },
                  child: const Column(
                    children: [
                      Icon(
                        Icons.photo,
                        color: POINT_COLOR,
                        size: 40,
                      ),
                      Text(
                        '앨범',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: POINT_COLOR,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    fetchBasicImage(widget.room_id);
                    Navigator.of(context).pop();
                  },
                  child: const Column(
                    children: [
                      Icon(
                        Icons.cancel,
                        color: POINT_COLOR,
                        size: 40,
                      ),
                      Text(
                        '기본 이미지',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: POINT_COLOR,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void editCoverDialog(
    String imageurl,
  ) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: ((context) {
          return AlertDialog(
            backgroundColor: LIGHTGREY,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: const Text("커버 이미지 수정",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: POINT_COLOR)),
            content: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_pickedImage != File('assets/images/turtle_noradius.png'))
                    Flexible(
                      child: Stack(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 30, 0),
                            child: SizedBox(
                              width: 120,
                              height: 120,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network(
                                  imageurl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          // 카메라 아이콘
                          Positioned(
                            bottom: 5,
                            right: 35,
                            child: InkWell(
                              onTap: () => showModalBottomSheet(
                                  context: context,
                                  builder: ((builder) => editRoomImg())),
                              child: const Icon(
                                Icons.camera_enhance,
                                color: PRIMARY_COLOR,
                                size: 40,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Flexible(
                      child: Stack(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 30, 0),
                            child: SizedBox(
                              width: 120,
                              height: 120,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.file(File(_pickedImage!.path)),
                              ),
                            ),
                          ),
                          // 카메라 아이콘
                          Positioned(
                            bottom: 5,
                            right: 35,
                            child: InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: ((builder) => editRoomImg()));
                              },
                              child: const Icon(
                                Icons.camera_enhance,
                                color: PRIMARY_COLOR,
                                size: 40,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            actions: <Widget>[
              // 수정 버튼
              ElevatedButton(
                onPressed: () async {
                  if (_pickedImage !=
                      File('assets/images/turtle_noradius.png')) {
                    await fetchRoomImage(_pickedImage, widget.room_id);
                  }
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: POINT_COLOR,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  side: const BorderSide(
                    color: POINT_COLOR,
                    width: 1.0,
                  ),
                ),
                child: const Text(
                  "수정",
                  style: TextStyle(
                      color: Color.fromARGB(226, 255, 255, 255),
                      fontWeight: FontWeight.bold),
                ),
              ),

              // 닫기 버튼
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: POINT_COLOR,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  side: const BorderSide(
                    color: POINT_COLOR,
                    width: 1.0,
                  ),
                ),
                child: const Text("취소",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          );
        }));
  }
}
