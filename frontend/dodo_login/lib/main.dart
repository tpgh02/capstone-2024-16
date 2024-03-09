import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:insta_clone/firebase_options.dart';
import 'package:insta_clone/providers/auth_provider.dart' as MyAuthProvider;
import 'package:insta_clone/providers/auth_state.dart';
import 'package:insta_clone/repositories/auth_repository.dart';
import 'package:insta_clone/screens/main_screen.dart';
import 'package:insta_clone/screens/signin_screen.dart';
import 'package:insta_clone/screens/splach_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //FirebaseAuth.instance.signOut();
    return MultiProvider(
      providers: [
        Provider<AuthRepository>(
          create: (context) => AuthRepository(
              firebaseAuth: FirebaseAuth.instance,
              firebaseStorage: FirebaseStorage.instance,
              firebaseFirestore: FirebaseFirestore.instance),
        ),
        StateNotifierProvider<MyAuthProvider.AuthProvider, AuthState>(
            create: (context) => MyAuthProvider.AuthProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        home: SplashScreen(),
      ),
    );
  }
}
