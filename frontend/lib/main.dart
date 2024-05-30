import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'package:dodo/components/items.dart';
import 'package:dodo/screen/AIroom_cr.dart';
import 'package:dodo/screen/AIroom_cr2.dart';
import 'package:dodo/screen/AIroom_cr3.dart';
import 'package:dodo/screen/Groproom_cr.dart';
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
import 'package:dodo/screen/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

  // 알림 초기화
  await _initializeNotifications();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignupPage(), //loginPage(),
    );
  }
}

// 알림 초기화 함수
Future<void> _initializeNotifications() async {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Timezone 초기화
  tz.initializeTimeZones();

  // 매주 월요일 9시에 알림 예약
  await _scheduleWeeklyMondayNotification(flutterLocalNotificationsPlugin);
}

// 매주 월요일 9시에 알림 예약 함수
Future<void> _scheduleWeeklyMondayNotification(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'weekly monday notification channel id',
    'weekly monday notification channel name',
    'weekly monday notification description',
    importance: Importance.max,
    priority: Priority.high,
    showWhen: false,
  );

  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.zonedSchedule(
    0,
    '새로운 한 주가 시작되었어요!',
    '즐거운 한 주 보내세요!',
    _nextInstanceOfMondayNineAM(),
    platformChannelSpecifics,
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
    matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
  );
}

// 다음 월요일 9시 시간을 계산하는 함수
tz.TZDateTime _nextInstanceOfMondayNineAM() {
  tz.TZDateTime scheduledDate = _nextInstanceOfNineAM();
  while (scheduledDate.weekday != DateTime.monday) {
    scheduledDate = scheduledDate.add(const Duration(days: 1));
  }
  return scheduledDate;
}

// 다음 9시 시간을 계산하는 함수
tz.TZDateTime _nextInstanceOfNineAM() {
  final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  tz.TZDateTime scheduledDate =
      tz.TZDateTime(tz.local, now.year, now.month, now.day, 9);
  if (scheduledDate.isBefore(now)) {
    scheduledDate = scheduledDate.add(const Duration(days: 1));
  }
  return scheduledDate;
}
