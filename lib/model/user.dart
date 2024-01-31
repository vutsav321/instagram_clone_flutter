import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  User({
    required this.email,
    required this.bio,
    required this.uid,
    required this.username,
    required this.photoURL,
    required this.following,
    required this.followers,
  });
  String username;
  String uid;
  String email;
  String bio;
  String photoURL;
  List following;
  List followers;

  Map<String, dynamic> tojson() => {
        'username': username,
        'uid': uid,
        'email': email,
        'bio': bio,
        'followers': [],
        'following': [],
        'photoURL': photoURL,
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = (snap.data() as Map<String, dynamic>);
    return User(
        email: snapshot['email'],
        bio: snapshot['bio'],
        uid: snapshot['uid'],
        username: snapshot['username'],
        photoURL: snapshot['photoURL'],
        following: snapshot['following'],
        followers: snapshot['followers']);
  }
}
