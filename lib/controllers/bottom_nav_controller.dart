import 'package:get/get.dart';

import 'user_controller.dart';

class BottomNavController extends GetxController {
  static BottomNavController get instance => Get.find();

  final index = 0.obs;

  void onTap(int selectedIndex) {
    index.value = selectedIndex;
  }
}
