import 'dart:convert';
import 'dart:developer';

import 'package:dodo/const/colors.dart';
import 'package:dodo/const/server.dart';
import 'package:flutter/material.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<void> fetchCreate(Map formData) async {
  final response = await http.post(
    Uri.parse(serverUrl + '/api/v1/creature/update-sea'),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(formData),
  );
  try {
    if (response.statusCode == 200) {
      print('연결 성공!');
    } else {
      print('서버 응답 데이터: ${response.body}');
      log('서버 응답 코드 : ${response.statusCode}');
      if (response.body.isNotEmpty) {
        print('서버 응답 데이터: ${response.body}');
      }
      throw Exception('인증방 생성이 실패했습니다. 잠시 후 시도해주십시오');
    }
  } catch (e) {
    print('네트워크 오류: ${e}');
    throw Exception('네트워크 오류가 발생했습니다');
  }
}

// 좌표를 저장하는 함수
Future<void> saveCoordinates(double x, double y) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setDouble('xCoordinate', x);
  await prefs.setDouble('yCoordinate', y);
}

// 저장된 좌표를 불러오는 함수
Future<List<double>> getCoordinates() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  double x = prefs.getDouble('xCoordinate') ?? 0.0;
  double y = prefs.getDouble('yCoordinate') ?? 0.0;
  return [x, y];
}

class overview_sea extends StatefulWidget {
  final int c_id;
  final String img;
  const overview_sea(this.c_id, this.img);
  @override
  _overview_seaState createState() => _overview_seaState();
}

class _overview_seaState extends State<overview_sea> {
  Matrix4? matrix;
  late ValueNotifier<Matrix4?> notifier;
  late Boxer boxer;
  double? tx;
  double? ty;

  @override
  void initState() {
    super.initState();
    matrix = Matrix4.identity();
    notifier = ValueNotifier(matrix);
    tx = 0.0;
    ty = 0.0;
  }

  @override
  void dispose() {
    notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (ctx, constraints) {
          var width = constraints.biggest.width / 10;
          var height = constraints.biggest.height / 10;
          var dx = (constraints.biggest.width - width) / 2;
          var dy = (constraints.biggest.height - height) / 2;
          matrix!.leftTranslate(dx, dy);
          boxer = Boxer(Offset.zero & constraints.biggest,
              Rect.fromLTWH(0, 0, width, height));

          return MatrixGestureDetector(
            shouldRotate: false,
            onMatrixUpdate: (m, tm, sm, rm) {
              matrix = MatrixGestureDetector.compose(matrix!, tm, sm, null);
              boxer.clamp(matrix!);
              notifier.value = matrix;

              final tx = matrix!.storage[12]; // x 좌표
              final ty = matrix!.storage[13]; // y 좌표
              print('x 좌표: $tx, y 좌표: $ty');
              this.tx = tx;
              this.ty = ty;
            },
            child: Stack(children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                child: Image.asset(
                  "assets/images/sea.png",
                  fit: BoxFit.cover,
                ),
              ),
              AnimatedBuilder(
                builder: (ctx, child) {
                  return Transform(
                    transform: matrix!,
                    child: Image.network(
                      widget.img,
                      fit: BoxFit.cover,
                      scale: 4,
                    ),
                  );
                },
                animation: notifier,
              ),
              //취소 저장 버튼
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        flex: 1,
                        child: OutlinedButton(
                          onPressed: () {
                            if (tx != null && ty != null) {
                              saveCoordinates(tx!, ty!); // y 좌표는 0으로 설정
                            }
                            Map format = {
                              "seaCreatureId": widget.c_id,
                              "coordinate_x": tx,
                              "coordinate_y": ty,
                              "isActivate": false
                            };
                            fetchCreate(format).then((data) {
                              print("오케이");
                              Navigator.pop(context);
                            }).catchError((error) {
                              print("에러$error");
                              print("$format");
                            });
                          },
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white,
                              elevation: 2,
                              foregroundColor: Colors.black,
                              shadowColor: Colors.black,
                              side: const BorderSide(color: PRIMARY_COLOR),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          child: const Text("삭제",
                              style: TextStyle(
                                  color: PRIMARY_COLOR,
                                  fontFamily: "bm",
                                  fontSize: 20)),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex: 2,
                        child: OutlinedButton(
                          onPressed: () {
                            if (tx != null && ty != null) {
                              saveCoordinates(tx!, ty!); // y 좌표는 0으로 설정
                            }
                            Map format = {
                              "seaCreatureId": 1,
                              "coordinate_x": tx,
                              "coordinate_y": ty,
                              "isActivate": true
                            };
                            fetchCreate(format).then((data) {
                              print("오케이");
                              Navigator.pop(context);
                            }).catchError((error) {
                              print("에러$error");
                              print("$format");
                            });
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: PRIMARY_COLOR,
                              elevation: 2,
                              foregroundColor: Colors.black,
                              shadowColor: Colors.black,
                              side: const BorderSide(color: PRIMARY_COLOR),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          child: const Text(
                            "저장",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "bm",
                                fontSize: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ]),
          );
        },
      ),
    );
  }
}

class Boxer {
  final Rect bounds;
  final Rect src;
  late Rect dst;

  Boxer(this.bounds, this.src);

  void clamp(Matrix4 m) {
    dst = MatrixUtils.transformRect(m, src);
    if (bounds.left <= dst.left &&
        bounds.top <= dst.top &&
        bounds.right >= dst.right &&
        bounds.bottom >= dst.bottom) {
      return;
    }

    if (dst.width > bounds.width || dst.height > bounds.height) {
      Rect intersected = dst.intersect(bounds);
      FittedSizes fs = applyBoxFit(BoxFit.contain, dst.size, intersected.size);

      vector.Vector3 t = vector.Vector3.zero();
      intersected = Alignment.center.inscribe(fs.destination, intersected);
      if (dst.width > bounds.width)
        t.y = intersected.top;
      else
        t.x = intersected.left;

      var scale = fs.destination.width / src.width;
      vector.Vector3 s = vector.Vector3(scale, scale, 0);
      m.setFromTranslationRotationScale(t, vector.Quaternion.identity(), s);
      return;
    }

    if (dst.left < bounds.left) {
      m.leftTranslate(bounds.left - dst.left, 0.0);
    }
    if (dst.top < bounds.top) {
      m.leftTranslate(0.0, bounds.top - dst.top);
    }
    if (dst.right > bounds.right) {
      m.leftTranslate(bounds.right - dst.right, 0.0);
    }
    if (dst.bottom > bounds.bottom) {
      m.leftTranslate(0.0, bounds.bottom - dst.bottom);
    }
  }
}
