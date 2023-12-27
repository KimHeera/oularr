import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:gidomoa/controllers/user_controller.dart';

import '../models/comments_model.dart';
import '../models/post_model.dart';

class PostRepository {
  PostRepository._privateConstructor();
  static final PostRepository _instance = PostRepository._privateConstructor();
  static PostRepository get instance => _instance;

  final _postCollection = FirebaseFirestore.instance.collection('post');
  final _commentsCollection = FirebaseFirestore.instance.collection('post');

  /// 게시물 올리기
  Future<void> addPostToFirebase(
      String pid, String content, String image) async {
    try {
      await _postCollection.doc(pid).set(
            PostModel.add(
              UserController.instance.currentUserUid,
              pid,
              content,
              image,
            ).toMap(),
          );
      if (kDebugMode) {
        print("[SUCCESS] Add post");
      }
    } catch (error) {
      if (kDebugMode) {
        print("[post_repository / addPostToFirebase] $error");
      }
    }
  }

  /// 모든 게시물 가져오기
  Future<void> getPostList() async {
    List<PostModel> postModelList = <PostModel>[];
    List<CommentsModel> commentsList = <CommentsModel>[];
    try {
      await _postCollection.get().then((QuerySnapshot qs) {
        for (var doc in qs.docs) {
          PostModel postModel =
              PostModel.fromMap(doc.data() as Map<String, dynamic>);
          postModelList.add(postModel);
        }
      });
      postModelList.shuffle();
      UserController.instance.postModelList.value = (postModelList);
      UserController.instance.currentPostModel.value = postModelList[0];

      await _commentsCollection
          .doc(postModelList[0].pid)
          .collection('comments')
          .orderBy('createdTime', descending: true)
          .get()
          .then((QuerySnapshot qs) {
        if (qs.docs.isEmpty) {
          if (kDebugMode) {
            print("[SUCCESS] There are no comments");
          }
          UserController.instance.commentsModelList.value = [];
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
        UserController.instance.commentsModelList.value = (commentsList);
      });

      if (kDebugMode) {
        print("[SUCCESS] Get post list");
      }
    } catch (error) {
      if (kDebugMode) {
        print("[post_repository / getPostList] $error");
      }
    }
  }

  /// 게시물 좋아요 - 로컬 값과 파베 값 동시에 업로드
  Future<void> likePost(String uid, String pid) async {
    try {
      UserController.instance.isLikedCurrentPost.value = true;
      UserController.instance.currentPostModel.value.prayers!
          .add(UserController.instance.currentUserUid);
      await _postCollection.doc(pid).update({
        'prayers': FieldValue.arrayUnion([uid]),
      });
    } catch (error) {
      if (kDebugMode) {
        print("[post_repository.dart - likePost] $error");
      }
    }
  }

  /// 게시물 좋아요 취소 - 로컬 값과 파베 값 동시에 업로드
  Future<void> dislikePost(String uid, String pid) async {
    try {
      UserController.instance.isLikedCurrentPost.value = false;
      UserController.instance.currentPostModel.value.prayers!
          .remove(UserController.instance.currentUserUid);
      await _postCollection.doc(pid).update({
        'prayers': FieldValue.arrayRemove([uid]),
      });
    } catch (error) {
      if (kDebugMode) {
        print("[post_repository.dart - dislikePost] $error");
      }
    }
  }

  ///user의 모든 게시글 가져오기
  Future<void> getMyPostList() async {
    List<PostModel> postList = <PostModel>[];
    try {
      await _postCollection
          .where('uid', isEqualTo: UserController.instance.currentUserUid)
          .orderBy('createdTime', descending: true)
          .get()
          .then((QuerySnapshot qs) {
        for (var doc in qs.docs) {
          PostModel postModel =
              PostModel.fromMap(doc.data() as Map<String, dynamic>);
          postList.add(postModel);
        }
        UserController.instance.myPostModelList.value = (postList);
      });
      if (kDebugMode) {
        print("[SUCCESS] Get My PostList");
      }
    } catch (error) {
      if (kDebugMode) {
        print("[post_repository / getMyPostList] $error");
      }
    }
  }

  ///user가 기도한 게시글 가져오기
  Future<void> getMyPrayedList() async {
    List<PostModel> prayedList = <PostModel>[];
    try {
      await _postCollection
          .where('prayers',
              arrayContains: UserController.instance.currentUserUid)
          .get()
          .then((QuerySnapshot qs) {
        for (var doc in qs.docs) {
          PostModel prayedModel =
              PostModel.fromMap(doc.data() as Map<String, dynamic>);
          prayedList.add(prayedModel);
        }
        UserController.instance.myPrayedModelList.value = (prayedList);
      });
      if (kDebugMode) {
        print("[SUCCESS] Get My Prayed list");
      }
    } catch (error) {
      if (kDebugMode) {
        print("[post_repository / getMyPrayedList] $error");
      }
    }
  }
}
