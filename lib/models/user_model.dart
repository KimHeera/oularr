// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  String? uid;
  String? email;
  String? photoUrl;
  String? displayName;
  String? prayerTitle;
  DateTime? createdTime;

  UserModel({
    required this.uid,
    required this.email,
    required this.photoUrl,
    required this.displayName,
    required this.prayerTitle,
    required this.createdTime,
  });

  UserModel copyWith({
    String? uid,
    String? email,
    String? photoUrl,
    String? displayName,
    String? prayerTitle,
    DateTime? createdTime,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      displayName: displayName ?? this.displayName,
      prayerTitle: prayerTitle ?? this.prayerTitle,
      createdTime: createdTime ?? this.createdTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'email': email,
      'photoUrl': photoUrl,
      'displayName': displayName,
      'prayerTitle': prayerTitle,
      'createdTime': createdTime,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] != null ? map['uid'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      photoUrl: map['photoUrl'] != null ? map['photoUrl'] as String : null,
      displayName:
          map['displayName'] != null ? map['displayName'] as String : null,
      prayerTitle:
          map['prayerTitle'] != null ? map['prayerTitle'] as String : null,
      createdTime: map['createdTime'] != null
          ? DateTime.parse(map['createdTime'].toDate().toString())
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  factory UserModel.empty() {
    return UserModel(
      uid: '',
      email: '',
      photoUrl: '',
      displayName: '',
      prayerTitle: '',
      createdTime: DateTime.now(),
    );
  }

  factory UserModel.emailSignUp(User user, String nickName) {
    return UserModel(
      uid: user.uid,
      email: user.email,
      photoUrl: '',
      displayName: nickName,
      prayerTitle: '아직 기도 제목이 없습니다.',
      createdTime: DateTime.now(),
    );
  }

  factory UserModel.googleSignUp(User user) {
    return UserModel(
      uid: user.uid,
      email: user.email,
      photoUrl: user.photoURL,
      displayName: user.displayName,
      prayerTitle: '아직 기도 제목이 없습니다.',
      createdTime: DateTime.now(),
    );
  }
}
