// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CommunityModel {
  String? cid;
  String? title;
  String? code;
  List<String>? users;
  String? hostUid;
  DateTime? createdTime;

  CommunityModel({
    required this.cid,
    required this.title,
    required this.code,
    required this.users,
    required this.hostUid,
    required this.createdTime,
  });

  CommunityModel copyWith({
    String? cid,
    String? title,
    String? code,
    List<String>? users,
    String? hostUid,
    DateTime? createdTime,
  }) {
    return CommunityModel(
      cid: cid ?? this.cid,
      title: title ?? this.title,
      code: code ?? this.code,
      users: users ?? this.users,
      hostUid: hostUid ?? this.hostUid,
      createdTime: createdTime ?? this.createdTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cid': cid,
      'title': title,
      'code': code,
      'users': users,
      'hostUid': hostUid,
      'createdTime': createdTime,
    };
  }

  factory CommunityModel.fromMap(Map<String, dynamic> map) {
    return CommunityModel(
      cid: map['cid'] != null ? map['cid'] as String : null,
      title: map['title'] != null ? map['title'] as String : null,
      code: map['code'] != null ? map['code'] as String : null,
      users: map['users'] != null ? List<String>.from(map['users']) : null,
      hostUid: map['hostUid'] != null ? map['hostUid'] as String : null,
      createdTime: map['createdTime'] != null
          ? DateTime.parse(map['createdTime'].toDate().toString())
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CommunityModel.fromJson(String source) =>
      CommunityModel.fromMap(json.decode(source) as Map<String, dynamic>);

  factory CommunityModel.empty() {
    return CommunityModel(
      cid: '',
      title: '',
      code: '',
      users: [],
      hostUid: '',
      createdTime: DateTime.now(),
    );
  }

  factory CommunityModel.add(
      String cid, String title, String code, String hostUid) {
    return CommunityModel(
      cid: cid,
      title: title,
      code: code,
      hostUid: hostUid,
      users: [hostUid],
      createdTime: DateTime.now(),
    );
  }
}
