import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram_flutter_clone/resources/firestore_method.dart';
import 'package:instagram_flutter_clone/screen/comment_screen.dart';
import 'package:instagram_flutter_clone/utils/colors.dart';
import 'package:instagram_flutter_clone/widget/like_anmation.dart';
import 'package:intl/intl.dart';

import '../controller/userdata_controller.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({super.key, required this.snap});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  @override
  void initState() {
    super.initState();
    getcomments();
  }

  bool _isLikeAnimating = false;
  int commentLen = 0;

  getcomments() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postid'])
          .collection('comments')
          .get();
      commentLen = snap.docs.length;
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.put(UserController());
    final width = MediaQuery.of(context).size.width;
    return Container(
      color: mobileBackgroundColor,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                .copyWith(right: 0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(widget.snap['profileImage']),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.snap['username'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ]),
                  ),
                ),
                widget.snap['uid'] == userController.userData.value!.uid
                    ? IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              child: ListView(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                shrinkWrap: true,
                                children: [
                                  'Delete',
                                ]
                                    .map(
                                      (e) => InkWell(
                                        onTap: () async {
                                          await FirestoreMethods().deletePost(
                                              widget.snap['postid']);
                                          Get.back();
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12, horizontal: 16),
                                          child: Text(e),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          );
                        },
                        icon: Icon(Icons.more_vert))
                    : Container()
              ],
            ),
          ),
          // Image Section
          GestureDetector(
            onDoubleTap: () async {
              await FirestoreMethods().likePost(widget.snap['postid'],
                  userController.userData.value!.uid, widget.snap['likes']);
              setState(() {
                _isLikeAnimating = true;
              });
            },
            child: Stack(alignment: Alignment.center, children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: double.infinity,
                  child: Image.network(
                    widget.snap['postURL'],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              AnimatedOpacity(
                duration: Duration(milliseconds: 200),
                opacity: _isLikeAnimating ? 1 : 0,
                child: LikeAnimation(
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 120,
                  ),
                  isAnimating: _isLikeAnimating,
                  duration: Duration(milliseconds: 400),
                  onEnd: () {
                    setState(() {
                      _isLikeAnimating = false;
                    });
                  },
                ),
              ),
            ]),
          ),
          // Likes Comment share
          Row(
            children: [
              LikeAnimation(
                isAnimating: widget.snap['likes']
                    .contains(userController.userData.value!.uid),
                smallLike: true,
                child: IconButton(
                    onPressed: () async {
                      await FirestoreMethods().likePost(
                          widget.snap['postid'],
                          userController.userData.value!.uid,
                          widget.snap['likes']);
                    },
                    icon: widget.snap['likes']
                            .contains(userController.userData.value!.uid)
                        ? Icon(
                            Icons.favorite,
                            color: Colors.red,
                          )
                        : Icon(Icons.favorite_border)),
              ),
              IconButton(
                  onPressed: () {
                    Get.to(CommentScreen(
                      postId: widget.snap['postid'],
                    ));
                  },
                  icon: Icon(Icons.comment_outlined)),
              IconButton(onPressed: () {}, icon: Icon(Icons.send)),
              Expanded(
                  child: Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                    onPressed: () {}, icon: Icon(Icons.bookmark_outline)),
              ))
            ],
          ),
          // description
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.snap['likes'].length} likes',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(top: 8),
                  child: RichText(
                    text: TextSpan(
                        style: TextStyle(color: primaryColor),
                        children: [
                          TextSpan(
                              text: widget.snap['username'],
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: '  ${widget.snap['description']}'),
                        ]),
                  ),
                ),
                commentLen != 0
                    ? InkWell(
                        onTap: () {
                          Get.to(CommentScreen(
                            postId: widget.snap['postid'],
                          ));
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            'Veiw all ${commentLen} comments',
                            style:
                                TextStyle(color: secondaryColor, fontSize: 16),
                          ),
                        ),
                      )
                    : Container(),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    DateFormat.yMMMd().format(
                      widget.snap['datePublished'].toDate(),
                    ),
                    style: TextStyle(color: secondaryColor, fontSize: 16),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
