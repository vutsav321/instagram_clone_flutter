import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
import 'package:instagram_flutter_clone/widget/post_card.dart';

import '../utils/colors.dart';
import '../utils/global.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor:
            width > webscreensize ? webBackgroundColor : mobileBackgroundColor,
        appBar: width > webscreensize
            ? null
            : AppBar(
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
                  IconButton(onPressed: () {}, icon: Icon(Icons.send_rounded))
                ],
              ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('posts').snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(color: primaryColor),
              );
            }
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) => Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: width > webscreensize ? width * 0.3 : 0,
                        vertical: width > webscreensize ? 15 : 0,
                      ),
                      child: PostCard(
                        snap: snapshot.data!.docs[index],
                      ),
                    ));
          },
        ),
      ),
    );
  }
}
