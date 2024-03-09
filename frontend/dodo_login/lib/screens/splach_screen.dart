import 'package:flutter/material.dart';
import 'package:insta_clone/providers/auth_state.dart';
import 'package:insta_clone/screens/main_screen.dart';
import 'package:insta_clone/screens/signin_screen.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authStatus = context.watch<AuthState>().authStatus;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //메인페이지로 이동
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => authStatus == AuthStatus.authenticated
              ? MainScreen()
              : SigninScreen(),
        ),
        (route) => route.isFirst, //false 그 위에 쌓음, isfirst는 맨 위만 남음
      );
    });
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
