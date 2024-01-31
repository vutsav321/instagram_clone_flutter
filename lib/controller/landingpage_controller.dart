import 'package:flutter/material.dart';
import 'package:get/get.dart ';

class LandingPageController extends GetxController {
  late PageController pageController;
  var tabIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
  }

  @override
  void onClose() {
    super.onClose();
    pageController.dispose();
  }
}
