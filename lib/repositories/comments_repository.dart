import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:gidomoa/controllers/user_controller.dart';

import '../models/comments_model.dart';

class CommentsRepository {
  CommentsRepository._privateConstructor();
  static final CommentsRepository _instance =
      CommentsRepository._privateConstructor();
  static CommentsRepository get instance => _instance;

  final _commentsCollection = FirebaseFirestore.instance.collection('post');

  /// 댓글 달기
  Future<void> addCommentsToFirebase(
      String pid, String cid, String comment) async {
    try {
      await _commentsCollection.doc(pid).collection('comments').doc(cid).set(
            CommentsModel.add(
              cid,
              UserController.instance.currentUserUid,
              comment,
              UserController.instance.currentUserName!,
            ).toMap(),
          );
      if (kDebugMode) {
        print("[SUCCESS] Add Comment");
      }
    } catch (error) {
      if (kDebugMode) {
        print("[comment_repository / addCommentToFirebase] $error");
      }
    }
  }

  /// 모든 댓글 가져오기
  Future<void> getCommentsList() async {
    List<CommentsModel> commentsList = <CommentsModel>[];
    try {
      await _commentsCollection
          .doc(UserController.instance.currentPostModel.value.pid)
          .collection('comments')
          .orderBy('createdTime', descending: false)
          .get()
          .then((QuerySnapshot qs) {
        if (qs.docs.isEmpty) {
          if (kDebugMode) {
            print("[SUCCESS] There are no comments");
          }
        } else {
          for (var doc in qs.docs) {
            CommentsModel commentsModel =
                CommentsModel.fromMap(doc.data() as Map<String, dynamic>);
            commentsList.add(commentsModel);
          }
          if (kDebugMode) {
            print("[SUCCESS] Get comments");
          }
        }
      });

      UserController.instance.commentsModelList.value = (commentsList);

      if (kDebugMode) {
        print("[SUCCESS] Get comments list");
      }
    } catch (error) {
      if (kDebugMode) {
        print("[comments_repository / getCommentsList] $error");
      }
    }
  }
}
