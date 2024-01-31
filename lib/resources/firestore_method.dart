import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_flutter_clone/model/post.dart';
import 'package:uuid/uuid.dart';
import 'storage_method.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // upload post
  Future<String> uploadPost(String description, Uint8List file, String uid,
      String username, String profileImage) async {
    String res = 'some error ocuured';

    try {
      String photoURL =
          await StorageMethod().uploadImageToStorage('posts', file, true);
      String postId = const Uuid().v1();
      Post post = Post(
          uid: uid,
          username: username,
          postid: postId,
          postURL: photoURL,
          description: description,
          datePublished: DateTime.now(),
          likes: [],
          profileImage: profileImage);

      _firestore.collection('posts').doc(postId).set(post.tojson());
      res = 'success';
    } on FirebaseException catch (err) {
      res = err.message.toString();
    }
    return res;
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> PostComment(String postId, String text, String profileImage,
      String name, String uid) async {
    String res = 'some error occurred';
    try {
      String commentId = const Uuid().v1();
      await _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .set({
        'postId': postId,
        'profileImage': profileImage,
        'text': text,
        'name': name,
        'uid': uid,
        'likes': [],
        'datePublished': DateTime.now(),
        'commentId': commentId
      });
      res = 'Success';
    } on FirebaseException catch (err) {
      res = err.message.toString();
    }
    return res;
  }

  Future<void> likeComment(
      String postId, String uid, List likes, String commentId) async {
    try {
      if (likes.contains(uid)) {
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (e) {
      print(e);
    }
  }

  Future<void> startfollowing(
      String currentUID, String uid, List followers) async {
    try {
      if (followers.contains(currentUID)) {
        await _firestore.collection('users').doc(uid).update({
          'followers': FieldValue.arrayRemove([currentUID]),
        });
        await _firestore.collection('users').doc(currentUID).update({
          'following': FieldValue.arrayRemove([uid])
        });
      } else {
        await _firestore.collection('users').doc(uid).update({
          'followers': FieldValue.arrayUnion([currentUID]),
        });
        await _firestore.collection('users').doc(currentUID).update({
          'following': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
