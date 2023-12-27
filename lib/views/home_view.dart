import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gidomoa/constant/app_constant.dart';
import 'package:gidomoa/repositories/post_repository.dart';
import 'package:uuid/uuid.dart';

import '../controllers/user_controller.dart';
import '../repositories/comments_repository.dart';
import '../routes/app_routes.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final userController = UserController.instance;
  final _textController = TextEditingController().obs;
  final comment = ''.obs;
  final isUploading = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBarWidget(),
      body: _bodyWidget(),
      floatingActionButton: _floatingButton(),
    );
  }

  _appBarWidget() {
    return AppBar(
      title: Text(
        '아울러',
        style: AppConstants.instance.title.copyWith(
          color: AppConstants.instance.primaryColor,
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
    );
  }

  _bodyWidget() {
    return FutureBuilder(
      future: userController.postModelListWithFuture.value,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return userController.postModelList.isEmpty
              ? const Center(
                  child: Text(
                    '아직 게시물이 없습니다.',
                  ),
                )
              : ListView(
                  children: [
                    /// 기도 카드
                    Stack(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: SizedBox(
                                width: 343,
                                height: 200,
                                child: Image.asset(
                                  userController.currentPostModel.value.image!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          onDoubleTap: () async {
                            if (userController.currentPostModel.value.prayers!
                                .contains(userController.currentUserUid)) {
                              await PostRepository.instance.dislikePost(
                                userController.currentUserUid,
                                userController.currentPostModel.value.pid!,
                              );
                            } else {
                              await PostRepository.instance.likePost(
                                userController.currentUserUid,
                                userController.currentPostModel.value.pid!,
                              );
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 343,
                                height: 200,
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 280,
                              height: 200,
                              child: Center(
                                child: Text(
                                  userController
                                      .currentPostModel.value.content!,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          right: 32,
                          bottom: 8,
                          child: Obx(() {
                            userController.isLikedCurrentPost.value =
                                userController.currentPostModel.value.prayers!
                                    .contains(userController.currentUserUid);
                            return Row(
                              children: [
                                IconButton(
                                  onPressed: () async {
                                    if (userController
                                        .currentPostModel.value.prayers!
                                        .contains(
                                            userController.currentUserUid)) {
                                      await PostRepository.instance.dislikePost(
                                        userController.currentUserUid,
                                        userController
                                            .currentPostModel.value.pid!,
                                      );
                                    } else {
                                      await PostRepository.instance.likePost(
                                        userController.currentUserUid,
                                        userController
                                            .currentPostModel.value.pid!,
                                      );
                                    }
                                  },
                                  icon: userController.isLikedCurrentPost.value
                                      ? Icon(
                                          Icons.volunteer_activism,
                                          size: 32,
                                          color: AppConstants
                                              .instance.primaryColor,
                                        )
                                      : const Icon(
                                          Icons.volunteer_activism_outlined,
                                          size: 32,
                                          color: Colors.white,
                                        ),
                                ),
                                Text(
                                  userController
                                      .currentPostModel.value.prayers!.length
                                      .toString(),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            );
                          }),
                        ),
                      ],
                    ),

                    /// 댓글창
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16.0,
                        horizontal: 16.0,
                      ),
                      child: SizedBox(
                        width: 343,
                        child: TextFormField(
                          cursorColor: Colors.grey,
                          style: AppConstants.instance.contentF,
                          controller: _textController.value,
                          minLines: 1,
                          maxLines: 5,
                          decoration: InputDecoration(
                            enabledBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16.0)),
                              borderSide: BorderSide(
                                  width: 2,
                                  color: Color.fromARGB(255, 207, 207, 207)),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16.0)),
                              borderSide: BorderSide(
                                width: 2,
                                color: Color.fromARGB(255, 207, 207, 207),
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.grey[200],
                            suffixIcon: Obx(() {
                              return IconButton(
                                icon: Icon(
                                  Icons.send,
                                  color: comment.value == ''
                                      ? Colors.grey
                                      : AppConstants.instance.primaryColor,
                                ),
                                onPressed: comment.value == ''
                                    ? null
                                    : isUploading.value
                                        ? () {}
                                        : () async {
                                            await _uploadComment();
                                            comment.value = '';
                                          },
                              );
                            }),
                          ),
                          onChanged: (value) {
                            comment.value = _textController.value.text;
                          },
                        ),
                      ),
                    ),

                    /// 댓글
                    Obx(() {
                      return FutureBuilder(
                        future:
                            userController.commentsModelListWithFuture.value,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              itemCount:
                                  userController.commentsModelList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Column(
                                  children: [
                                    Container(
                                      height: 72,
                                      width: 375,
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 24,
                                              width: 375,
                                              child: Text(
                                                userController
                                                    .commentsModelList[index]
                                                    .senderName!,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 32,
                                              width: 375,
                                              child: Text(
                                                userController
                                                    .commentsModelList[index]
                                                    .comment!,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                ),
                                                overflow: TextOverflow.fade,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 1,
                                      width: 367,
                                      color: Colors.grey,
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            return Center(
                              child: CircularProgressIndicator(
                                color: AppConstants.instance.primaryColor,
                              ),
                            );
                          }
                        },
                      );
                    }),
                  ],
                );
        } else {
          return Center(
            child: CircularProgressIndicator(
              color: AppConstants.instance.primaryColor,
            ),
          );
        }
      },
    );
  }

  _floatingButton() {
    return FloatingActionButton.extended(
      backgroundColor: AppConstants.instance.primaryColor,
      onPressed: () {
        Get.toNamed(AppRoutes.instance.WRITING);
      },
      icon: const Icon(
        Icons.create,
      ),
      isExtended: false,
      label: const Text(''),
    );
  }

  _uploadComment() async {
    isUploading.value = true;
    await CommentsRepository.instance.addCommentsToFirebase(
      userController.currentPostModel.value.pid!,
      const Uuid().v4(),
      comment.value,
    );
    await UserController.instance.commentsModelListWithFuture();

    isUploading.value = false;
    _textController.value.text = '';
    userController.reloadCommentsListWithFuture();
    // Get.offAllNamed(AppRoutes.instance.BOTTOM);
    // Get.back();
  }
}
