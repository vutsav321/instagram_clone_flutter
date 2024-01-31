import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter_clone/screen/add_post_screen.dart';
import 'package:instagram_flutter_clone/screen/feed_screen.dart';
import 'package:instagram_flutter_clone/screen/profile_screen.dart';
import 'package:instagram_flutter_clone/screen/search_screen.dart';

const webscreensize = 600;

List<Widget> homeScreenItems = [
  const FeedScreen(),
  const SearchScreen(),
  const AddPostScreen(),
  const Text('Notification'),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  )
];
