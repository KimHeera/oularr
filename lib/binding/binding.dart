import 'package:get/get.dart';
import 'package:gidomoa/controllers/bottom_nav_controller.dart';

import '../controllers/auth_controller.dart';
import '../controllers/user_controller.dart';

class InitBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(AuthController());
  }
}

class MainBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(UserController());
    Get.put(BottomNavController());
  }
}
