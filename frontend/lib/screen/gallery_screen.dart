import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:dodo/const/colors.dart';
import 'package:dodo/const/server.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<List<Certification>> fetchImg() async {
  var headers = {
    'Authorization':
        'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjF9.8PJk4wE2HsDlgLmFA_4PU2Ckb7TWmXfG0Hfz2pRE9WU'
  };
  final response = await http.get(Uri.parse('${serverUrl}/api/v1/report/album'),
      headers: headers);
  if (response.statusCode == 200) {
    Iterable certificationList = jsonDecode(utf8.decode(response.bodyBytes));
    log('$certificationList');
    List<Certification> certifications =
        certificationList.map((json) => Certification.fromJson(json)).toList();
    return certifications;
  } else {
    throw Exception('Failed to load album');
  }
}

class Certification {
  final int certificationId;
  final ImageData image;
  final String date;

  Certification({
    required this.certificationId,
    required this.image,
    required this.date,
  });

  factory Certification.fromJson(dynamic json) {
    return Certification(
      certificationId: json['certificationId'],
      image: ImageData.fromJson(json['image']),
      date: json['date'],
    );
  }
}

class ImageData {
  final int id;
  final String url;

  ImageData({
    required this.id,
    required this.url,
  });

  factory ImageData.fromJson(dynamic json) {
    return ImageData(
      id: json['id'],
      url: json['url'],
    );
  }
}

class galleryPage extends StatefulWidget {
  const galleryPage({super.key});

  @override
  State<galleryPage> createState() => _galleryPageState();
}

class _galleryPageState extends State<galleryPage> {
  final GlobalKey _globalKey = GlobalKey();
  bool downloading = false;
  String progressString = "";

  Future<void> _captureAndSave() async {
    try {
      setState(() {
        downloading = true;
      });

      RenderRepaintBoundary boundary = _globalKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage();
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      log('Saving image to gallery');
      // final result = await ImageGallerySaver.saveImage(pngBytes);
      // log('Image saved: $result');

      setState(() {
        downloading = false;
      });

      Fluttertoast.showToast(
        msg: "이미지 다운로드 완료!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } catch (e) {
      setState(() {
        downloading = false;
      });
      log('Error during download: $e');
      Fluttertoast.showToast(
        msg: "다운로드 중 오류 발생: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final String lastMonth = (now.month - 1).toString() + '월';

    return Scaffold(
      backgroundColor: LIGHTGREY,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: POINT_COLOR,
                    ),
                  ),
                  const Text(
                    "사진첩",
                    style: TextStyle(
                        fontFamily: 'bm', fontSize: 30, color: POINT_COLOR),
                  ),
                ],
              ),
              RepaintBoundary(
                key: _globalKey,
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 2),
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text(
                            lastMonth,
                            style:
                                const TextStyle(fontSize: 24, fontFamily: "bm"),
                          ),
                          const SizedBox(height: 16),
                          FutureBuilder<List<Certification>>(
                            future: fetchImg(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Center(
                                      child: Text(
                                    '오류가 발생했습니다. 잠시 후 시도해 주십시오',
                                    style: TextStyle(
                                        fontFamily: 'bm',
                                        color: DARKGREY,
                                        fontSize: 25),
                                  )),
                                );
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.isEmpty) {
                                return Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Center(
                                      child: Text(
                                    '이미지가 없습니다.',
                                    style: TextStyle(
                                        fontFamily: 'bm',
                                        color: DARKGREY,
                                        fontSize: 25),
                                  )),
                                );
                              } else {
                                return GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                  ),
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    final certification = snapshot.data![index];
                                    return Image.network(
                                      certification.image.url,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: downloading ? null : _captureAndSave,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: PRIMARY_COLOR,
                          ),
                          child: Text(
                            downloading ? progressString : "이미지로 다운받기",
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'bm',
                              fontSize: 20,
                            ),
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
}
