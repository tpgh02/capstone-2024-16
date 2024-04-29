import 'package:dodo/const/colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class Certification extends StatefulWidget {
  final String state;
  const Certification(this.state);

  @override
  State<Certification> createState() => _CertificationState();
}

class _CertificationState extends State<Certification> {
  GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  File? _image;
  TextEditingController _emailEditingController = TextEditingController();
  TextEditingController _nameEditingController = TextEditingController();
  TextEditingController _passwordEditingController = TextEditingController();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  bool _isEnabled = true;

  Future<void> pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image, // select only images
    );
    if (result != null) {
      if (result.files.single.path != null) {
        setState(() {
          _isEnabled = true;
          _image = File(result.files.single.path!);
          print('File Path: ${_image!.path}');
        });
      } else {
        print('File path is null');
      }
    } else {
      // If the user cancels the selection
      print("No image selected");
    }
  }

  @override
  Widget build(BuildContext context) {
    const TextStyle style =
        TextStyle(color: Colors.white, fontFamily: "kcc", fontSize: 30);
    int c_length = 4; //인증개수
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 20),
          c_length == 1
              ? Container(
                  width: 180,
                  height: 180,
                  child: InkWell(
                    onTap: () {
                      pickImage(); //이미지 저장
                    },
                    child: Stack(
                      children: [
                        if (_image != null)
                          Container(
                            // width: 50,
                            // height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: DARKGREY,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                _image!,
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
                )
              : SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: List.generate(
                      c_length,
                      (index) => Container(
                        width: 180,
                        height: 180,
                        child: InkWell(
                          onTap: () {
                            pickImage(); //이미지 저장
                          },
                          child: Stack(
                            children: [
                              if (_image != null)
                                Container(
                                  // width: 50,
                                  // height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: DARKGREY,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.file(
                                      _image!,
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
                      ),
                    ),
                  ),
                )
        ],
      ),
    );
  }
}

//팝업 띄우는 함수
void statedialog(context, state, File? _image) {
  bool _isEnabled = _image != null;
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "인증하기",
              style: TextStyle(fontFamily: "kcc", fontSize: 20),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              color: Colors.red,
              alignment: Alignment.center,
              child: Stack(
                children: [
                  _image == null
                      ? Container(
                          // width: 50,
                          // height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Image.asset(
                            'assets/images/turtle_noradius.png',
                          ),
                        )
                      : Container(
                          // width: 50,
                          // height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: _image != null
                                ? DecorationImage(
                                    image: FileImage(_image),
                                  )
                                : null,
                          ),
                        ),
                  Positioned(
                    left: 80,
                    bottom: -10,
                    child: IconButton(
                      onPressed: _isEnabled
                          ? () async {
                              // Do something
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
      );
    },
  );
}
