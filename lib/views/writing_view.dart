import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gidomoa/constant/app_constant.dart';
import 'package:gidomoa/repositories/post_repository.dart';
import 'package:uuid/uuid.dart';

class WritineView extends StatelessWidget {
  WritineView({super.key});

  final TextEditingController _textController = TextEditingController();
  final prayText = ''.obs;
  final isUploading = false.obs;
  final prayImage = 'assets/images/img0.jpeg'.obs;
  final selected = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return isUploading.value
            ? Container(
                color: Colors.white,
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppConstants.instance.primaryColor,
                  ),
                ),
              )
            : Scaffold(
                backgroundColor: Colors.white,
                appBar: _appBarWidget(),
                body: _boddyWidget(),
                bottomSheet: _bottomSheetWidget(),
              );
      },
    );
  }

  _appBarWidget() {
    return AppBar(
      title: Text(
        '내 기도제목 올리기',
        style: AppConstants.instance.title.copyWith(
          color: AppConstants.instance.primaryColor,
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        onPressed: Get.back,
        icon: Icon(
          Icons.arrow_back_ios,
          color: AppConstants.instance.primaryColor,
        ),
      ),
    );
  }

  _boddyWidget() {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: SizedBox(
              width: 343,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      prayImage.value = 'assets/images/img0.jpeg';
                      selected.value = 0;
                    },
                    child: Stack(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: SizedBox(
                                width: 80,
                                height: 50,
                                child: Image.asset(
                                  'assets/images/img0.jpeg',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 80,
                              height: 50,
                              decoration: BoxDecoration(
                                border: selected == 0
                                    ? Border.all(
                                        width: 2,
                                        color: Colors.orange,
                                      )
                                    : Border.all(
                                        width: 0,
                                        color: Colors.orange,
                                      ),
                                color: Colors.black.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: InkWell(
                      onTap: () {
                        prayImage.value = 'assets/images/img1.jpg';
                        selected.value = 1;
                      },
                      child: Stack(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: SizedBox(
                                  width: 80,
                                  height: 50,
                                  child: Image.asset(
                                    'assets/images/img1.jpg',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 80,
                                height: 50,
                                decoration: BoxDecoration(
                                  border: selected == 1
                                      ? Border.all(
                                          width: 2,
                                          color: Colors.orange,
                                        )
                                      : Border.all(
                                          width: 0,
                                          color: Colors.orange,
                                        ),
                                  color: Colors.black.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: InkWell(
                      onTap: () {
                        prayImage.value = 'assets/images/img2.avif';
                        selected.value = 2;
                      },
                      child: Stack(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: SizedBox(
                                  width: 80,
                                  height: 50,
                                  child: Image.asset(
                                    'assets/images/img2.avif',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 80,
                                height: 50,
                                decoration: BoxDecoration(
                                  border: selected == 2
                                      ? Border.all(
                                          width: 2,
                                          color: Colors.orange,
                                        )
                                      : Border.all(
                                          width: 0,
                                          color: Colors.orange,
                                        ),
                                  color: Colors.black.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: InkWell(
                      onTap: () {
                        prayImage.value = 'assets/images/img3.jpg';
                        selected.value = 3;
                      },
                      child: Stack(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: SizedBox(
                                  width: 80,
                                  height: 50,
                                  child: Image.asset(
                                    'assets/images/img3.jpg',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 80,
                                height: 50,
                                decoration: BoxDecoration(
                                  border: selected == 3
                                      ? Border.all(
                                          width: 2,
                                          color: Colors.orange,
                                        )
                                      : Border.all(
                                          width: 0,
                                          color: Colors.orange,
                                        ),
                                  color: Colors.black.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        width: 343,
                        height: 200,
                        child: Image.asset(
                          prayImage(),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 280,
                      height: 200,
                      child: Obx(() {
                        return Center(
                          child: Text(
                            prayText.value,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            width: 343,
            child: TextFormField(
              cursorColor: Colors.grey,
              style: AppConstants.instance.contentF,
              maxLength: 100,
              controller: _textController,
              minLines: 5,
              maxLines: 5,
              decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                  borderSide: BorderSide(
                      width: 2, color: Color.fromARGB(255, 207, 207, 207)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                  borderSide: BorderSide(
                      width: 2, color: Color.fromARGB(255, 207, 207, 207)),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) {
                prayText.value = _textController.text;
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 32),
            child: Text(
              '* 부적절한 내용은 제재를 받을 수 있습니다.\n* 해당 게시물은 모든 사용자에게 공개됩니다.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  _bottomSheetWidget() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: _uploadPost,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(343, 60),
              backgroundColor: AppConstants.instance.primaryColor,
            ),
            child: const Text(
              '기도 올리기',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _uploadPost() async {
    isUploading.value = true;
    await PostRepository.instance.addPostToFirebase(
      const Uuid().v4(),
      prayText.value,
      prayImage.value,
    );
    isUploading.value = false;
    Get.back();
  }
}
