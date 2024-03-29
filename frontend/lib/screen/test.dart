import 'package:dodo/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

//main 화면에서 상태 멘트를 날려주는 컴포넌트

class certification extends StatefulWidget {
  final String state;
  const certification(this.state);

  @override
  State<certification> createState() => _certificationState();
}

class _certificationState extends State<certification> {
  GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  Uint8List? _image;
  TextEditingController _emailEditingcontroller = TextEditingController();
  TextEditingController _nameEditingcontroller = TextEditingController();
  TextEditingController _passwordEditingcontroller = TextEditingController();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  bool _isEnabled = true;
  Future<void> selectImage() async {
    ImagePicker imagePicker = new ImagePicker();
    XFile? file = await imagePicker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 512,
      maxWidth: 512,
    );

    if (file != null) {
      Uint8List uint8list = await file.readAsBytes();
      setState(() {
        _image = uint8list;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const TextStyle style =
        TextStyle(color: Colors.white, fontFamily: "kcc", fontSize: 30);
    return Center(
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: PRIMARY_COLOR,
              minimumSize: Size(100, 100),
              elevation: 5, //그림자
            ),
            onPressed: () {
              statedialog(context, 70, _image);
            },
            child: Container(
              alignment: Alignment.center,
              child: Text(
                "인증하기",
                //스타일은 위에 지정해둠.
                style: style,
              ),
            )));
  }
}

//팝업 띄우는 함수
void statedialog(context, state, Uint8List? _image) {
  _certificationState certificationState = _certificationState();
  bool _isEnabled = true;
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
          child: SizedBox(
        width: 300,
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //오늘의 todo 달성률을 보여주는 팝업
            const Text(
              "인증하기",
              style: TextStyle(fontFamily: "kcc", fontSize: 20),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              alignment: Alignment.center,
              child: Stack(
                children: [
                  _image == null
                      ? Container(
                          width: 128,
                          height: 128,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Image.asset(
                              '../assets/images/turtle_noradius.png'),
                        )
                      : Container(
                          width: 128,
                          height: 128,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                64), // 반지름을 지정하여 모서리를 둥글게 만듭니다.
                            image: _image != null
                                ? DecorationImage(image: MemoryImage(_image!))
                                : null, // 이미지를 배경으로 설정합니다.
                          ),
                        ),
                  Positioned(
                    left: 80,
                    bottom: -10,
                    child: IconButton(
                      onPressed: _isEnabled
                          ? () async {
                              await certificationState.selectImage();
                            }
                          : null,
                      icon: Icon(Icons.add_a_photo),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.close),
            )
          ],
        ),
      ));
    },
  );
}
