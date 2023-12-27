import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:gidomoa/models/community_model.dart';
import 'package:gidomoa/repositories/community_repository.dart';
import 'package:gidomoa/repositories/user_repository.dart';

import '../models/comments_model.dart';
import '../models/post_model.dart';
import '../models/user_model.dart';
import '../repositories/comments_repository.dart';
import '../repositories/post_repository.dart';
import '../service/auth_service.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();

  final currentUserModel = UserModel.empty().obs;
  final currentUserUid = FirebaseAuth.instance.currentUser!.uid;
  final currentUserName = FirebaseAuth.instance.currentUser!.displayName;

  final currentPostModel = PostModel.empty().obs; // Home에서 뜨는 Post 모델
  final isLikedCurrentPost = false.obs; // Home에서 뜨는 현재 Post를 좋아요 했는지 여부
  final postModelList =
      <PostModel>[].obs; // reloadPostListWithFuture() 실행시 최신화 됨.
  final postModelListWithFuture =
      Future.value().obs; // Home FutureBuilder의 future 값

  ///commnets 변수들
  final commentsModelList =
      <CommentsModel>[].obs; // reloadPostListWithFuture() 실행시 최신화 됨.
  final commentsModelListWithFuture =
      Future.value().obs; // comments FutureBuilder의 future 값

  /// 나의 기도들 변수들
  final myPostModelList = <PostModel>[].obs;
  final myPostModelListWithFuture = Future.value().obs;

  /// 내가 기도한 변수들
  final myPrayedModelList = <PostModel>[].obs;
  final myPrayedModelListWithFuture = Future.value().obs;

  ///그룹 내 유저들의 기도 변수들
  final prayerTitleModelList = <UserModel>[].obs;
  final prayerTitleModelListWithFuture = Future.value().obs;

  //그룹 page 변수들
  final currentCommunityModel =
      CommunityModel.empty().obs; // 그룹에서 뜨는 Community 모델
  final communityModelList =
      <CommunityModel>[].obs; // reloadCommunityListWithFuture() 실행시 최신화 됨.
  final communityModelListWithFuture =
      Future.value().obs; // 그룹 FutureBuilder의 future 값

  Future<void> init() async {
    await reloadPostListWithFuture();
    await reloadCommunityListWithFuture();
  }

  @override
  Future<void> onInit() async {
    UserModel userModel = await UserRepository.instance.getUser(currentUserUid);
    if (userModel.uid!.isEmpty) {
      await AuthService.instance.signOut();
    } else {
      currentUserModel.value = userModel;
    }
    super.onInit();
  }

  /// PostRepository.instance.getPostList();의 값을 담고 있는 변수를 갱신(새로고침) 해주는 함수
  Future<void> reloadPostListWithFuture() async {
    postModelListWithFuture.value = PostRepository.instance.getPostList();
  }

  /// CommunityRepository.instance.getCommunityList();의 값을 담고 있는 변수를 갱신(새로고침) 해주는 함수
  Future<void> reloadCommunityListWithFuture() async {
    communityModelListWithFuture.value =
        CommunityRepository.instance.getCommunityList();
  }

  ///comments 함수들
  Future<void> reloadCommentsListWithFuture() async {
    commentsModelListWithFuture.value =
        CommentsRepository.instance.getCommentsList();
  }

  ///내 기도들 함수들
  Future<void> reloadMyPostListWithFuture() async {
    myPostModelListWithFuture.value = PostRepository.instance.getMyPostList();
  }

  ///내가 기도한 게시글 함수들
  Future<void> reloadMyPrayedListWithFuture() async {
    myPrayedModelListWithFuture.value =
        PostRepository.instance.getMyPrayedList();
  }

  ///그룹원들의 기도제목 함수들
  Future<void> reloadPrayerTitlesListWithFuture() async {
    prayerTitleModelListWithFuture.value =
        CommunityRepository.instance.getPrayerTitleList();
  }
}
