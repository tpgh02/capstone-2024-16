import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:insta_clone/exceptions/custom_exception.dart';
import 'package:insta_clone/providers/auth_state.dart';
import 'package:insta_clone/repositories/auth_repository.dart';
import 'package:provider/provider.dart';

class AuthProvider extends StateNotifier<AuthState> with LocatorMixin {
  AuthProvider() : super(AuthState.init());

  @override
  void update(Locator watch) {
    final user = watch<User?>(); //계속 모니터링 하다가 user가 로그인되면 catch.

    //두 케이스가 없으면 순간적으로 로그인이 될 수 있음.
    if (user != null && !user.emailVerified) {
      return;
    } //인증은 받지 않은 상태
    //로그인이 한 번 됨.

    if (user == null && state.authStatus == AuthStatus.unauthenticated) {
      return;
    } // 미인증된 이메일로 로그인시.
    //로그인시 로그아웃으로 바꿔줌. unauth -> unauth. splash에서 감지해서 다시 보냄. 그럴 경우 밑으로 보내지 않도록.

    //로직
    if (user != null) {
      state = state.copyWith(
        authStatus: AuthStatus
            .authenticated, //status 변경, splash에서 watch하다가 발견하면 메인 스크린으로 넘김
      );
    } else {
      state = state.copyWith(
        authStatus: AuthStatus.unauthenticated,
      );
    }
  }

  Future<void> signOut() async {
    await read<AuthRepository>().signOut();

    state = state.copyWith(
      authStatus: AuthStatus.unauthenticated,
    );
  }

  Future<void> signUp({
    required String email,
    required String name,
    required String password,
    required Uint8List? profileImage,
  }) async {
    //비동기 -> 다른 작업을 수행하고, 데이터가 준비가 완료된다면 사용하는 식. 로딩을 띄울 수 있다.
    try {
      await read<AuthRepository>().signUp(
          email: email,
          name: name,
          password: password,
          profileImage: profileImage);
      state = state.copyWith(
        authStatus: AuthStatus.authenticated,
      );
    } on CustomException catch (_) {
      rethrow;
    }
  }

  Future<void> signin({
    required String email,
    required String password,
  }) async {
    try {
      read<AuthRepository>().signin(
        email: email,
        password: password,
      );
    } on CustomException catch (_) {
      rethrow;
    }
  }
}
