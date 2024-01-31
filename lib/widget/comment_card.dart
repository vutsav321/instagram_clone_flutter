import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:instagram_flutter_clone/controller/userdata_controller.dart';
import 'package:instagram_flutter_clone/resources/firestore_method.dart';
import 'package:instagram_flutter_clone/utils/colors.dart';
import 'package:instagram_flutter_clone/widget/like_anmation.dart';
import 'package:intl/intl.dart';

class CommentCard extends StatefulWidget {
  final snap;
  const CommentCard({super.key, required this.snap});

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.put(UserController());
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(widget.snap['profileImage']),
            radius: 18,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: 16,
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: widget.snap['name'],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: primaryColor),
                          ),
                          TextSpan(
                              text: '  ${widget.snap['text']}',
                              style: const TextStyle(color: primaryColor)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Text(
                        DateFormat.yMMMd().format(
                          widget.snap['datePublished'].toDate(),
                        ),
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w200),
                      ),
                    ),
                  ]),
            ),
          ),
          Column(children: [
            LikeAnimation(
              isAnimating: widget.snap['likes']
                  .contains(userController.userData.value!.uid),
              smallLike: true,
              child: IconButton(
                onPressed: () async {
                  await FirestoreMethods().likeComment(
                      widget.snap['postId'],
                      userController.userData.value!.uid,
                      widget.snap['likes'],
                      widget.snap['commentId']);
                },
                icon: widget.snap['likes']
                        .contains(userController.userData.value!.uid)
                    ? Icon(
                        Icons.favorite,
                        color: Colors.red,
                      )
                    : Icon(
                        Icons.favorite_border,
                      ),
              ),
            ),
            widget.snap['likes'].length != 0
                ? Text(
                    '${widget.snap['likes'].length}',
                    style: TextStyle(color: secondaryColor),
                  )
                : Container()
          ])
        ],
      ),
    );
  }
}
