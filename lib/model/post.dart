import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  Post(
      {required this.uid,
      required this.username,
      required this.postid,
      required this.postURL,
      required this.description,
      required this.datePublished,
      required this.likes,
      required this.profileImage});
  String username;
  String uid;
  String postid;
  String postURL;
  String description;
  final datePublished;
  String profileImage;
  final likes;

  Map<String, dynamic> tojson() => {
        'username': username,
        'uid': uid,
        'description': description,
        'postid': postid,
        'postURL': postURL,
        'datePublished': datePublished,
        'profileImage': profileImage,
        'likes': likes
      };

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = (snap.data() as Map<String, dynamic>);
    return Post(
        uid: snapshot['uid'],
        username: snapshot['username'],
        postURL: snapshot['postURL'],
        datePublished: snapshot['datePublished'],
        profileImage: snapshot['profileImage'],
        description: snapshot['description'],
        postid: snapshot['postid'],
        likes: snapshot['likes']);
  }
}
