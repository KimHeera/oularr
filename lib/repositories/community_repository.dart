import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:gidomoa/controllers/user_controller.dart';
import 'package:gidomoa/models/user_model.dart';

import '../models/community_model.dart';

class CommunityRepository {
  CommunityRepository._privateConstructor();
  static final CommunityRepository _instance =
      CommunityRepository._privateConstructor();
  static CommunityRepository get instance => _instance;

  final _communityCollection =
      FirebaseFirestore.instance.collection('community');

  /// 그룹 만들기
  Future<void> addCommunityToFirebase(
      String cid, String title, String code) async {
    try {
      await _communityCollection.doc(cid).set(
            CommunityModel.add(
              cid,
              title,
              code,
              UserController.instance.currentUserUid,
            ).toMap(),
          );
      if (kDebugMode) {
        print("[SUCCESS] Add Community");
      }
    } catch (error) {
      if (kDebugMode) {
        print("[community_repository / addCommunityToFirebase] $error");
      }
    }
  }

  /// user가 속한 모든 그룹 가져오기
  Future<void> getCommunityList() async {
    List<CommunityModel> communityList = <CommunityModel>[];
    try {
      await _communityCollection
          .where('users', arrayContains: UserController.instance.currentUserUid)
          .orderBy('createdTime', descending: true)
          .get()
          .then((QuerySnapshot qs) {
        for (var doc in qs.docs) {
          CommunityModel communityModel =
              CommunityModel.fromMap(doc.data() as Map<String, dynamic>);
          communityList.add(communityModel);
        }
        UserController.instance.communityModelList.value = (communityList);
      });
      if (kDebugMode) {
        print("[SUCCESS] Get community list");
      }
    } catch (error) {
      if (kDebugMode) {
        print("[community_repository / getCommunityList] $error");
      }
    }
  }

  /// join group
  Future<void> joinCommunity(String token) async {
    try {
      await _communityCollection
          .where('code', isEqualTo: token)
          .get()
          .then((QuerySnapshot qs) async {
        if (qs.docs.length != 1) {
          Get.snackbar('참여 불가', '존재하지 않는 토큰입니다.');
        } else {
          for (var doc in qs.docs) {
            CommunityModel communityModel =
                CommunityModel.fromMap(doc.data() as Map<String, dynamic>);

            print(communityModel.cid);
            print(UserController.instance.currentUserUid);

            await _communityCollection.doc(communityModel.cid).update({
              'users': FieldValue.arrayUnion(
                  [UserController.instance.currentUserUid]),
            });
            await UserController.instance.reloadCommunityListWithFuture();
          }
        }
      });
      if (kDebugMode) {
        print("[SUCCESS] Join community");
      }
    } catch (error) {
      if (kDebugMode) {
        print("[community_repository / joinCommunity] $error");
      }
    }
  }

  ///그룹원들의 기도제목 가져오기
  Future<void> getPrayerTitleList() async {
    try {
      UserController.instance.prayerTitleModelList.clear();
      for (var userUid
          in UserController.instance.currentCommunityModel.value.users!) {
        await FirebaseFirestore.instance
            .collection('user')
            .doc(userUid)
            .get()
            .then((DocumentSnapshot ds) {
          UserModel userModel =
              UserModel.fromMap(ds.data() as Map<String, dynamic>);
          UserController.instance.prayerTitleModelList.add(userModel);
        });
      }
      if (kDebugMode) {
        print("[SUCCESS] Get PrayerTitle list");
      }
    } catch (error) {
      if (kDebugMode) {
        print("[post_repository / getPrayerTitleList] $error");
      }
    }
  }

  // out group
  Future<void> outCommunity() async {
    List<String>? newArray =
        UserController.instance.currentCommunityModel.value.users;
    try {
      for (int i = 0; i < newArray!.length; i++) {
        if (newArray[i] == UserController.instance.currentUserUid) {
          newArray.removeAt(i);
          break;
        }
      }
      await FirebaseFirestore.instance
          .collection('community')
          .doc(UserController.instance.currentCommunityModel.value.cid)
          .update({'users': newArray});

      if (kDebugMode) {
        print("[SUCCESS] Out community list");
      }
    } catch (error) {
      if (kDebugMode) {
        print("[community_repository / outCommunityList] $error");
      }
    }
  }

  Future<void> deleteCommunity() async {
    try {
      await FirebaseFirestore.instance
          .collection('community')
          .doc(UserController.instance.currentCommunityModel.value.cid)
          .delete();
      if (kDebugMode) {
        print("[SUCCESS] Delete community list");
      }
    } catch (error) {
      if (kDebugMode) {
        print("[community_repository / deleteCommunityList] $error");
      }
    }
  }
}
