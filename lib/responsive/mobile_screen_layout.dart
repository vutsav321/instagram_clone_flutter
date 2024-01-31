import 'package:flutter/material.dart';
import 'package:instagram_flutter_clone/controller/landingpage_controller.dart';
import 'package:get/get.dart';
import 'package:instagram_flutter_clone/utils/colors.dart';
import 'package:instagram_flutter_clone/utils/global.dart';
import 'package:instagram_flutter_clone/widget/bottomnavigationbar.dart';

class MobileScreenLayout extends StatelessWidget {
  MobileScreenLayout({super.key});
  final landingPageController = Get.put(LandingPageController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          children: homeScreenItems,
          controller: landingPageController.pageController,
        ),
        bottomNavigationBar: buildBottomNavigationMenu(
            context, landingPageController, mobileBackgroundColor),
      ),
    );
  }
}
