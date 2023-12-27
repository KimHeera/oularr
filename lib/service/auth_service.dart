import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/user_model.dart';
import '../repositories/user_repository.dart';
import '../routes/app_routes.dart';

class AuthService {
  AuthService._privateConstructor();
  static final AuthService _instance = AuthService._privateConstructor();
  static AuthService get instance => _instance;

  /// 로그아웃
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut().then(
          (value) => Get.offAllNamed(AppRoutes.instance.LOGIN),
        );
  }

  /// Email Sign Up
  Future<User?> signUpWithEmailAndPassword(
      String email, String password, String nickName) async {
    try {
      UserCredential result =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = result.user;

      if (user != null) {
        await UserRepository.instance.addUserToFirebase(
          UserModel.emailSignUp(
            user,
            nickName,
          ),
        );
        Get.toNamed(
          AppRoutes.instance.LOGIN,
        );
        return user;
      }

      return user;
    } catch (error) {
      if (kDebugMode) {
        print(
            '[authentication.dart - signUpWithEmailAndPassword] email sign up failed');
        print(error.toString());
      }

      return null;
    }
  }

  /// Email Sign In
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      User? user = result.user;

      if (user != null) {
        Get.offAllNamed(
          AppRoutes.instance.BOTTOM,
        );
      }
    } catch (error) {
      if (kDebugMode) {
        print(
            '[authentication.dart - signInWithEmailAndPassword] email sign in failed');
        print(error);
      }
    }
  }

  /// 구글 로그인
  Future<User?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // Get a user info
      User? user = userCredential.user;

      if (user != null && userCredential.additionalUserInfo!.isNewUser) {
        await UserRepository.instance.addUserToFirebase(
          UserModel.googleSignUp(user),
        );
      }
      Get.offNamed(AppRoutes.instance.BOTTOM);

      if (kDebugMode) {
        print('[SUCCESS] Google Login');
      }

      return user;
    } catch (error) {
      if (kDebugMode) {
        print('[auth_service : signInWithGoogle] $error');
      }
      throw ();
    }
  }
}
