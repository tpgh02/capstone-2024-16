import 'package:dodo/components/items.dart';
import 'package:dodo/screen/AIroom_cr.dart';
import 'package:dodo/screen/AIroom_cr2.dart';
import 'package:dodo/screen/AIroom_cr3.dart';
import 'package:dodo/screen/buy_screen.dart';
import 'package:dodo/screen/findpass_screen.dart';
import 'package:dodo/screen/gallery_screen.dart';
import 'package:dodo/screen/inventory_screen.dart';
import 'package:dodo/screen/login_screen.dart';
import 'package:dodo/screen/main2_screen.dart';
import 'package:dodo/screen/report_screen.dart';
import 'package:dodo/screen/room_join.dart';
import 'package:dodo/screen/sea_screen.dart';
import 'package:dodo/screen/search2_screen.dart';
import 'package:dodo/screen/signup_screen.dart';
import 'package:dodo/screen/store_screen.dart';
import 'package:dodo/screen/Room_cr.dart';
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
      home: InvenPage(), //mainPage(),
    );
  }
}
