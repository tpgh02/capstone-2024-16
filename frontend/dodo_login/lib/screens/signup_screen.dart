import 'dart:typed_data';

import 'package:insta_clone/exceptions/custom_exception.dart';
import 'package:insta_clone/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_clone/screens/signin_screen.dart';
import 'package:insta_clone/widgets/error_dialog_widget.dart';
import 'package:provider/provider.dart' as MyAuthProvider;
import 'package:validators/validators.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
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
  void dispose() {
    _emailEditingcontroller.dispose();
    _nameEditingcontroller.dispose();
    _passwordEditingcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Form(
                key: _globalKey,
                autovalidateMode: _autovalidateMode,
                child: ListView(
                  shrinkWrap: true,
                  reverse: true,
                  children: [
                    //로고
                    SvgPicture.asset(
                      'assets/images/ic_instagram.svg',
                      height: 64,
                      colorFilter:
                          ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    //프로필 사진
                    Container(
                      alignment: Alignment.center,
                      child: Stack(
                        children: [
                          _image == null
                              ? CircleAvatar(
                                  radius: 64,
                                  backgroundImage: AssetImage(
                                    'assets/images/profile.png',
                                  ),
                                )
                              : CircleAvatar(
                                  radius: 64,
                                  backgroundImage: MemoryImage(_image!),
                                ),
                          Positioned(
                            left: 80,
                            bottom: -10,
                            child: IconButton(
                              onPressed: _isEnabled
                                  ? () async {
                                      await selectImage();
                                    }
                                  : null,
                              icon: Icon(Icons.add_a_photo),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    //이메일
                    TextFormField(
                      enabled: _isEnabled,
                      controller: _emailEditingcontroller,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email),
                        filled: true,
                      ),
                      validator: (value) {
                        //아무것도 입력하지 않았을 때
                        //공백만 입력했을 때
                        //이메일 형식이 아닐 때
                        if (value == null ||
                            value.trim().isEmpty ||
                            !isEmail(value.trim())) {
                          return '이메일을 입력해주세요';
                        }

                        return null;
                      },
                    ),
                    SizedBox(height: 20),

                    //이름
                    TextFormField(
                      enabled: _isEnabled,
                      controller: _nameEditingcontroller,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'name',
                        prefixIcon: Icon(Icons.account_circle),
                        filled: true,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return '이름을 입력해주세요';
                        }
                        if (value.length < 3 || value.length > 10) {
                          return '이름은 최소 3, 최대 10글자까지 가능';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),

                    //패스워드
                    TextFormField(
                      enabled: _isEnabled,
                      controller: _passwordEditingcontroller,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'password',
                        prefixIcon: Icon(Icons.lock),
                        filled: true,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return '패스워드를 입력해주세요';
                        }
                        if (value.length < 6) {
                          return '6글자 이상 입력해';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),

                    //패스워드 확인
                    TextFormField(
                      enabled: _isEnabled,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'confirm password',
                        prefixIcon: Icon(Icons.lock),
                        filled: true,
                      ),
                      validator: (value) {
                        if (_passwordEditingcontroller.text != value) {
                          return '패스워드 불일치';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: _isEnabled
                          ? () async {
                              final form = _globalKey.currentState;
                              _autovalidateMode = AutovalidateMode.always;
                              if (form == null || !form.validate()) {
                                return;
                              }
                              setState(() {
                                _isEnabled = false;
                                _autovalidateMode = AutovalidateMode.always;
                              });
                              //회원가입 로직
                              try {
                                await context.read<AuthProvider>().signUp(
                                    email: _emailEditingcontroller.text,
                                    name: _nameEditingcontroller.text,
                                    password: _passwordEditingcontroller.text,
                                    profileImage: _image);

                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SigninScreen(),
                                    ));

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('인증 메일을 전송했습니다.'),
                                    duration: Duration(seconds: 120),
                                  ),
                                );
                              } on CustomException catch (e) {
                                setState(() {
                                  _isEnabled = true;
                                });
                                errorDialogWidget(context, e);
                              }
                            }
                          : null,
                      child: Text('회원가입'),
                      style: ElevatedButton.styleFrom(
                        textStyle: TextStyle(fontSize: 20),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextButton(
                      onPressed: _isEnabled
                          ? () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SigninScreen(),
                              ))
                          : null,
                      child: Text(
                        '이미 회원이신가요? 로그인 하기',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ].reversed.toList(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
