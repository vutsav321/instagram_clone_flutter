import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram_flutter_clone/controller/userdata_controller.dart';
import 'package:instagram_flutter_clone/resources/firestore_method.dart';
import 'package:instagram_flutter_clone/utils/colors.dart';
import 'package:instagram_flutter_clone/widget/comment_card.dart';

class CommentScreen extends StatefulWidget {
  final String postId;
  const CommentScreen({super.key, required this.postId});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController _commentController = TextEditingController();

  void addComment(String profileImage, String uid, String name) async {
    try {
      String res = await FirestoreMethods().PostComment(
          widget.postId, _commentController.text, profileImage, name, uid);
      print(res);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userController = Get.put(UserController());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text('comments'),
        centerTitle: false,
      ),
      bottomNavigationBar: Container(
        height: kToolbarHeight,
        margin:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        padding: EdgeInsets.only(left: 16, right: 8),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage:
                  NetworkImage(userController.userData.value!.photoURL),
              radius: 18,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 8.0),
                child: TextField(
                  controller: _commentController,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                      hintText:
                          'Comment as ${userController.userData.value!.username}',
                      border: InputBorder.none),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                addComment(
                    userController.userData.value!.photoURL,
                    userController.userData.value!.uid,
                    userController.userData.value!.username);
                setState(() {
                  _commentController.text = '';
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: const Text(
                  'Post',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            )
          ],
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.postId)
            .collection('comments')
            .orderBy('datePublished', descending: true)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: primaryColor),
            );
          }
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) => CommentCard(
                    snap: snapshot.data!.docs[index],
                  ));
        },
      ),
    );
  }
}
