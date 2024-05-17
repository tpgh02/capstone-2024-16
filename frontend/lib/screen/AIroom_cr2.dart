import 'package:dodo/const/colors.dart';
import 'package:dodo/screen/AIroom_cr3.dart';
import 'package:flutter/material.dart';

class AIroom_cr2 extends StatefulWidget {
  const AIroom_cr2({super.key});

  @override
  State<AIroom_cr2> createState() => _AIroom_cr2State();
}

class _AIroom_cr2State extends State<AIroom_cr2> {
  List _roomname = ['운동', '기상', '학습'];
  Object? _select = '운동';
  TextEditingController _title = TextEditingController();
  TextEditingController _tag = TextEditingController();
  TextEditingController _comments = TextEditingController();
  TextEditingController _peoplenum = TextEditingController();
  TextEditingController _password = TextEditingController();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  bool _isAI = false;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LIGHTGREY,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          width: 390,
          height: 80,
          decoration: const ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 2,
                strokeAlign: BorderSide.strokeAlignOutside,
                color: Color(0x7F414C58),
              ),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(30, 20, 0, 0),
          child: const Text(
            'AI 인증방 생성',
            style: TextStyle(
              color: PRIMARY_COLOR,
              fontFamily: "bm",
              fontSize: 30,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _globalKey,
          autovalidateMode: _autovalidateMode,
          child: Column(
            children: [
              // 인증방 제목
              _buildTextFormField(
                controller: _title,
                labelText: '인증방 제목',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '제목을 입력해주세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // 카테고리 선택
              Container(width: double.infinity, child: _roomBtn()),
              const SizedBox(height: 20),
              // 해시태그 ( 선택 )
              _buildTextFormField(
                controller: _tag,
                labelText: '해시태그 ( 선택 )',
                validator: null,
              ),
              const SizedBox(height: 20),
              // 인증방 목표 (30자 미만)
              _buildTextFormField(
                controller: _comments,
                labelText: '인증방 목표 (30자 미만)',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '목표를 입력해주세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // 최대 인원 수
              _buildTextFormField(
                controller: _peoplenum,
                labelText: '최대 인원 수',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '최대 인원 수를 입력해주세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // 비밀번호 (입력시 비밀방으로 생성)
              _buildTextFormField(
                controller: _password,
                labelText: '비밀번호 (입력시 비밀방으로 생성)',
                validator: null,
              ),
              const SizedBox(height: 20),
              // 이전, 다음 버튼
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 2,
                      foregroundColor: Colors.black,
                      shadowColor: Colors.black,
                      side: const BorderSide(color: PRIMARY_COLOR),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "이전",
                      style: TextStyle(color: PRIMARY_COLOR),
                    ),
                  ),
                  const SizedBox(width: 10),
                  OutlinedButton(
                    onPressed: () async {
                      if (_globalKey.currentState!.validate()) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AIroom_cr3(
                                _title.text,
                                _select.toString(),
                                _tag.text,
                                _comments.text,
                                _peoplenum.text,
                                _password.text,
                                _isAI),
                          ),
                        );
                      } else {
                        setState(() {
                          _autovalidateMode = AutovalidateMode.always;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: PRIMARY_COLOR,
                      elevation: 2,
                      foregroundColor: Colors.black,
                      shadowColor: Colors.black,
                      side: const BorderSide(color: PRIMARY_COLOR),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "다음",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _roomBtn() {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: PRIMARY_COLOR, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: DropdownButton(
          value: _select,
          underline: const SizedBox.shrink(),
          focusColor: LIGHTGREY,
          iconEnabledColor: PRIMARY_COLOR,
          icon: const Icon(Icons.arrow_drop_down),
          items: _roomname.map(
            (value) {
              return DropdownMenuItem(
                value: value,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    value,
                    style: TextStyle(fontFamily: 'bm', fontSize: 20),
                  ),
                ),
              );
            },
          ).toList(),
          onChanged: (value) {
            setState(() {
              _select = value.toString();
            });
          },
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    required String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 48,
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(fontSize: 20, fontFamily: 'bma'),
            decoration: InputDecoration(
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide.none,
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: PRIMARY_COLOR),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              labelText: labelText,
              filled: true,
              fillColor: Colors.white,
              labelStyle: const TextStyle(
                color: POINT_COLOR,
                fontSize: 18,
                fontFamily: 'bm',
              ),
            ),
            validator: validator,
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
        ),
        Visibility(
          visible: controller.text.isNotEmpty &&
              validator?.call(controller.text) != null,
          child: Column(
            children: [
              const SizedBox(height: 5), // Error message와 필드 사이의 간격
              Text(
                validator?.call(controller.text) ?? '',
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
