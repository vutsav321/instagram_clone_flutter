import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram_flutter_clone/utils/colors.dart';

buildBottomNavigationMenu(context, landingPageController, backgroundColor) {
  return Obx(
    () => CupertinoTabBar(
      onTap: (value) {
        landingPageController.tabIndex.value = value;
        landingPageController.pageController.jumpToPage(value);
      },
      height: 50,
      currentIndex: landingPageController.tabIndex.value,
      inactiveColor: secondaryColor,
      activeColor: primaryColor,
      backgroundColor: backgroundColor,
      items: [
        BottomNavigationBarItem(
          icon: Container(
            margin: EdgeInsets.only(bottom: 7),
            child: Icon(
              Icons.home,
            ),
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Container(
            margin: EdgeInsets.only(bottom: 7),
            child: Icon(
              Icons.search,
            ),
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Container(
            margin: EdgeInsets.only(bottom: 7),
            child: Icon(
              Icons.add_circle,
            ),
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Container(
            margin: EdgeInsets.only(bottom: 7),
            child: Icon(
              Icons.favorite,
            ),
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Container(
            margin: EdgeInsets.only(bottom: 7),
            child: Icon(
              Icons.person,
            ),
          ),
          label: '',
        )
      ],
    ),
  );
}
