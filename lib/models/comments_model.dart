// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';

class CommentsModel {
  String? cid;
  String? uid;
  String? comment;
  String? senderName;
  DateTime? createdTime;

  CommentsModel({
    required this.cid,
    required this.uid,
    required this.comment,
    required this.senderName,
    required this.createdTime,
  });

  CommentsModel copyWith({
    String? cid,
    String? uid,
    String? comment,
    String? senderName,
    DateTime? createdTime,
  }) {
    return CommentsModel(
      cid: cid ?? this.cid,
      uid: uid ?? this.uid,
      comment: comment ?? this.comment,
      senderName: senderName ?? this.senderName,
      createdTime: createdTime ?? this.createdTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cid': cid,
      'uid': uid,
      'comment': comment,
      'senderName': senderName,
      'createdTime': createdTime,
    };
  }

  factory CommentsModel.fromMap(Map<String, dynamic> map) {
    return CommentsModel(
      cid: map['cid'] != null ? map['cid'] as String : null,
      uid: map['uid'] != null ? map['uid'] as String : null,
      comment: map['comment'] != null ? map['comment'] as String : null,
      senderName:
          map['senderName'] != null ? map['senderName'] as String : null,
      createdTime: map['createdTime'] != null
          ? DateTime.parse(map['createdTime'].toDate().toString())
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CommentsModel.fromJson(String source) =>
      CommentsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  factory CommentsModel.empty() {
    return CommentsModel(
      cid: '',
      uid: '',
      comment: '',
      senderName: '',
      createdTime: DateTime.now(),
    );
  }

  factory CommentsModel.add(
      String cid, String uid, String comment, String senderName) {
    return CommentsModel(
      cid: cid,
      uid: uid,
      comment: comment,
      senderName: senderName,
      createdTime: DateTime.now(),
    );
  }
}
