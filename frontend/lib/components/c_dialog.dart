import 'dart:convert';
import 'dart:developer';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dodo/const/colors.dart';
import 'package:dodo/const/server.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;

Future<List<Map<String, dynamic>>> fetchRooms() async {
  final response =
      await http.get(Uri.parse('$serverUrl/api/v1/room/list'), headers: {
    'Authorization':
        'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjF9.8PJk4wE2HsDlgLmFA_4PU2Ckb7TWmXfG0Hfz2pRE9WU'
  });
  if (response.statusCode == 200) {
    final List<dynamic> jsonData = jsonDecode(utf8.decode(response.bodyBytes));
    log("Main2 : Connected!");
    return List<Map<String, dynamic>>.from(jsonData);
  } else {
    throw Exception('Failed to load room list in main');
  }
}

class c_dialog extends StatefulWidget {
  final int room_id;
  const c_dialog(this.room_id);

  @override
  State<c_dialog> createState() => _c_dialogState();
}

class _c_dialogState extends State<c_dialog> {
  final ImagePicker _picker = ImagePicker();
  final List<File?> _pickedImages = [];
  String? status;
  int frequency = 3;

  @override
  void initState() {
    super.initState();
    _fetchRoomDetails();
  }

  Future<void> _fetchRoomDetails() async {
    try {
      List<Map<String, dynamic>> rooms = await fetchRooms();
      var room = rooms.firstWhere((room) => room['roomId'] == widget.room_id,
          orElse: () => {});
      if (room.isEmpty) {
        Fluttertoast.showToast(
          msg: "잠시 후 시도해주십시오",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        Navigator.of(context).pop();
      } else {
        setState(() {
          status = room['status'];
          frequency = room['frequency'] ?? 1;
        });
      }
    } catch (e) {
      log('Error fetching room details: $e');
      Fluttertoast.showToast(
        msg: "잠시 후 시도해주십시오",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      Navigator.of(context).pop();
    }
  }

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
    return status == null || frequency == 0
        ? const Center(child: CircularProgressIndicator())
        : Dialog(
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                height: 500,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: AutoSizeText(
                            status == 'wait'
                                ? "인증을 기다리는 중이에요"
                                : status == 'success'
                                    ? "챌린지를 완료했어요"
                                    : "오늘의 도전을\n아직 완료하지 않았어요",
                            style:
                                const TextStyle(fontFamily: 'bm', fontSize: 25),
                            maxLines:
                                2, // Set the maximum number of lines to avoid overflow
                            minFontSize: 10, // Set the minimum font size
                            overflow: TextOverflow
                                .ellipsis, // Handle overflow if it happens
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(
                            Icons.close,
                          ),
                        ),
                      ],
                    ),
                    status == 'success'
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/images/turtle.png",
                                scale: 2,
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              const Text(
                                "대단해요!",
                                style: TextStyle(
                                    color: POINT_COLOR,
                                    fontFamily: 'bma',
                                    fontSize: 20),
                              ),
                              const Text(
                                "내일도 화이팅이예요~",
                                style: TextStyle(
                                    color: POINT_COLOR,
                                    fontFamily: 'bma',
                                    fontSize: 20),
                              )
                            ],
                          )
                        : Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Column(
                              children: [
                                SingleChildScrollView(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  child: Column(
                                    children: [
                                      Column(
                                        children:
                                            List.generate(frequency, (index) {
                                          return select(index);
                                        }),
                                      ),
                                      const SizedBox(
                                        height: 100,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.bottomCenter,
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: 40,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        await patchUserProfileImage(
                                            _pickedImages, widget.room_id);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: PRIMARY_COLOR,
                                      ),
                                      child: const Text(
                                        "확인",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'bm',
                                            fontSize: 20),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ],
                ),
              ),
            ),
          );
  }

  Future<dynamic> patchUserProfileImage(
      List<File?> pickedImages, int roomId) async {
    print("프로필 사진을 서버에 업로드 합니다.");
    var dio = Dio();
    var url = serverUrl + '/api/v1/certification/upload';

    try {
      final List<MultipartFile> _files =
          await Future.wait(pickedImages.map((img) async {
        if (img != null) {
          return await MultipartFile.fromFile(
            img.path,
            filename: img.path.split('/').last,
            contentType: MediaType("image", "jpg"),
          );
        } else {
          throw Exception('이미지 파일이 유효하지 않습니다.');
        }
      }).toList());

      dio.options.contentType = 'multipart/form-data';
      dio.options.headers = {
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjF9.8PJk4wE2HsDlgLmFA_4PU2Ckb7TWmXfG0Hfz2pRE9WU',
        'Content-Type': 'multipart/form-data',
      };

      FormData formData = FormData.fromMap({
        "certificationId": 1,
        "roomId": roomId,
        "img": _files,
      });

      print('FormData contents: ${formData.fields}');
      print('FormData files: ${formData.files}');

      final response = await dio.post(url, data: formData);

      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');
      print('Response headers: ${response.headers}');

      if (response.statusCode == 200) {
        print('성공적으로 업로드했습니다');
      } else {
        Fluttertoast.showToast(
          msg: "서버로부터 잘못된 응답이 도착했습니다. 상태 코드: ${response.statusCode}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "업로드 중 오류 발생: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      print('업로드 중 오류 발생: $e');
    }
  }

  Widget select(int index) {
    return Container(
      width: 180,
      height: 180,
      color: LIGHTGREY,
      margin: const EdgeInsets.symmetric(vertical: 10),
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
