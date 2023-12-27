import 'dart:convert';

class PostModel {
  String? uid;
  String? pid;
  String? content;
  String? image;
  List<String>? prayers;
  DateTime? createdTime;

  PostModel({
    required this.uid,
    required this.pid,
    required this.content,
    required this.image,
    required this.prayers,
    required this.createdTime,
  });

  PostModel copyWith({
    String? uid,
    String? pid,
    String? content,
    String? image,
    List<String>? prayers,
    DateTime? createdTime,
  }) {
    return PostModel(
      uid: uid ?? this.uid,
      pid: pid ?? this.pid,
      content: content ?? this.content,
      image: image ?? this.image,
      prayers: prayers ?? this.prayers,
      createdTime: createdTime ?? this.createdTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'pid': pid,
      'content': content,
      'image': image,
      'prayers': prayers!.toSet().toList(),
      'createdTime': createdTime,
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      uid: map['uid'] != null ? map['uid'] as String : null,
      pid: map['pid'] != null ? map['pid'] as String : null,
      content: map['content'] != null ? map['content'] as String : null,
      image: map['image'] != null ? map['image'] as String : null,
      prayers:
          map['prayers'] != null ? List<String>.from(map['prayers']) : null,
      createdTime: map['createdTime'] != null
          ? DateTime.parse(map['createdTime'].toDate().toString())
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PostModel.fromJson(String source) =>
      PostModel.fromMap(json.decode(source) as Map<String, dynamic>);

  factory PostModel.empty() {
    return PostModel(
      uid: '',
      pid: '',
      content: '',
      image: '',
      prayers: [],
      createdTime: DateTime.now(),
    );
  }

  factory PostModel.add(String uid, String pid, String content, String image) {
    return PostModel(
      uid: uid,
      pid: pid,
      image: image,
      content: content,
      prayers: [],
      createdTime: DateTime.now(),
    );
  }
}
