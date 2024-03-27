import 'package:dodo/screen/findpass_screen.dart';
import 'package:dodo/screen/login_screen.dart';
import 'package:dodo/screen/room_join.dart';
import 'package:dodo/screen/signup_screen.dart';
import 'package:dodo/screen/test.dart';
import 'package:flutter/material.dart';
import 'package:dodo/screen/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: certification("hello"),
    );
  }
}
