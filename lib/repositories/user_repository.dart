import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../controllers/user_controller.dart';
import '../models/user_model.dart';

class UserRepository {
  UserRepository._privateConstructor();
  static final UserRepository _instance = UserRepository._privateConstructor();
  static UserRepository get instance => _instance;

  final _userCollection = FirebaseFirestore.instance.collection('user');

  /// 유저 올리기
  Future<void> addUserToFirebase(UserModel userModel) async {
    try {
      await _userCollection.doc(userModel.uid).set(userModel.toMap());
      if (kDebugMode) {
        print("[SUCCESS] User is created");
      }
    } catch (error) {
      if (kDebugMode) {
        print("[post_repository / addPostToFirebase] $error");
      }
    }
  }

  /// 유저 정보 가져오기
  Future<UserModel> getUser(String uid) async {
    UserModel userModel = UserModel.empty();
    try {
      await _userCollection.doc(uid).get().then((DocumentSnapshot ds) {
        if (ds.exists) {
          userModel = UserModel.fromMap(ds.data() as Map<String, dynamic>);
          if (kDebugMode) {
            print("[SUCCESS] Get user");
          }
        } else {
          if (kDebugMode) {
            print("[FAILURE] No data");
          }
        }
      });
    } catch (error) {
      if (kDebugMode) {
        print("[user_repository.dart - getUser] $error");
      }
    }
    return userModel;
  }

  ///유저 삭제하기
  Future<void> deleteUser() async {
    try {
      await FirebaseFirestore.instance
          .collection('user')
          .doc(UserController.instance.currentUserUid)
          .delete();
      await FirebaseAuth.instance.currentUser?.delete();
      if (kDebugMode) {
        print("[SUCCESS] Delete user");
      }
    } catch (error) {
      if (kDebugMode) {
        print("[user_repository / deleteUser] $error");
      }
    }
  }
}
