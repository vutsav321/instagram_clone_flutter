import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:instagram_flutter_clone/controller/landingpage_controller.dart';
import 'package:instagram_flutter_clone/controller/userdata_controller.dart';
import 'package:instagram_flutter_clone/utils/colors.dart';
import 'package:instagram_flutter_clone/utils/global.dart';

class WebScreenLayout extends StatelessWidget {
  WebScreenLayout({super.key});
  final userController = Get.put(UserController());
  final landingPageController = Get.put(LandingPageController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          centerTitle: false,
          title: SvgPicture.asset(
            'assets/ic_instagram.svg',
            colorFilter: ColorFilter.mode(
              primaryColor,
              BlendMode.srcIn,
            ),
            height: 32,
          ),
          actions: [
            Obx(() => IconButton(
                onPressed: () {
                  landingPageController.tabIndex.value = 0;
                  landingPageController.pageController.jumpToPage(0);
                },
                icon: Icon(
                  Icons.home,
                  color: landingPageController.tabIndex.value == 0
                      ? primaryColor
                      : secondaryColor,
                ))),
            Obx(() => IconButton(
                onPressed: () {
                  landingPageController.tabIndex.value = 1;
                  landingPageController.pageController.jumpToPage(1);
                },
                icon: Icon(
                  Icons.search,
                  color: landingPageController.tabIndex.value == 1
                      ? primaryColor
                      : secondaryColor,
                ))),
            Obx(() => IconButton(
                onPressed: () {
                  landingPageController.tabIndex.value = 2;
                  landingPageController.pageController.jumpToPage(2);
                },
                icon: Icon(
                  Icons.add_circle_outline,
                  color: landingPageController.tabIndex.value == 2
                      ? primaryColor
                      : secondaryColor,
                ))),
            Obx(() => IconButton(
                onPressed: () {
                  landingPageController.tabIndex.value = 3;
                  landingPageController.pageController.jumpToPage(3);
                },
                icon: Icon(
                  Icons.favorite,
                  color: landingPageController.tabIndex.value == 3
                      ? primaryColor
                      : secondaryColor,
                ))),
            Obx(() => IconButton(
                onPressed: () {
                  landingPageController.tabIndex.value = 4;
                  landingPageController.pageController.jumpToPage(4);
                },
                icon: Icon(
                  Icons.person,
                  color: landingPageController.tabIndex.value == 4
                      ? primaryColor
                      : secondaryColor,
                ))),
          ],
        ),
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          children: homeScreenItems,
          controller: landingPageController.pageController,
        ),
      ),
    );
  }
}
