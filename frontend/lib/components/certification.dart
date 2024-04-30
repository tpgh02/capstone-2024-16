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
  final ImagePicker _picker = ImagePicker();
  final List<XFile?> _pickedImages = [];
  void getImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    setState(() {
      _pickedImages.add(image);
    });
  }

  @override
  Widget build(BuildContext context) {
    const TextStyle style =
        TextStyle(color: Colors.white, fontFamily: "kcc", fontSize: 30);
    int c_length = 1; //인증개수
    return Flexible(
        child: SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: Column(
        children: List.generate(c_length, (index) {
          return select(index);
        }),
      ),
    ));
  }

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
                    File(_pickedImages[index]!.path), // XFile을 File로 변환
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
