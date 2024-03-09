import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insta_clone/exceptions/custom_exception.dart';
import 'package:insta_clone/providers/auth_provider.dart';
import 'package:insta_clone/providers/auth_state.dart';
import 'package:insta_clone/screens/signup_screen.dart';
import 'package:insta_clone/utils/logger.dart';
import 'package:insta_clone/widgets/error_dialog_widget.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:validators/validators.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  TextEditingController _emailEditingcontroller = TextEditingController();
  TextEditingController _passwordEditingcontroller = TextEditingController();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  bool _isEnabled = true;

  @override
  void dispose() {
    _emailEditingcontroller.dispose();
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
                            isEmail(value.trim())) {
                          return '이메일을 입력해주세요';
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
                              //로그인 로직
                              try {
                                logger.d(context.read<AuthState>().authStatus);

                                context.read<AuthProvider>().signin(
                                      email: _emailEditingcontroller.text,
                                      password: _passwordEditingcontroller.text,
                                    );
                              } on CustomException catch (e) {
                                setState(() {
                                  _isEnabled = true;
                                });
                                errorDialogWidget(context, e);
                              }
                            }
                          : null,
                      child: Text('로그인'),
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
                                builder: (context) => SignupScreen(),
                              ))
                          : null,
                      child: Text(
                        '회원 아님? 회원가입하기',
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
