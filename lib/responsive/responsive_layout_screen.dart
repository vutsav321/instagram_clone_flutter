import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:instagram_flutter_clone/utils/global.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;
  ResponsiveLayout(
      {required this.webScreenLayout, required this.mobileScreenLayout});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > webscreensize) {
        return webScreenLayout;
      }
      return mobileScreenLayout;
    });
  }
}
