import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduquality/views/widgets/screens/bookmarkVideo_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:eduquality/views/widgets/screens/add_video_screen.dart';
import 'package:eduquality/views/widgets/screens/profile_screen.dart';
import 'package:eduquality/views/widgets/screens/search_screen.dart';
import 'package:eduquality/views/widgets/screens/video_screen.dart';
import 'controllers/auth_controller.dart';

List pages = [
  VideoScreen(),
  BookmarkVideoScreen(),
  //SearchScreen(),
  const AddVideoScreen(),
  const Center(child: Text('Messages Screen')),
  ProfileScreen(uid: authController.user.uid),
];
List pagesNonAdmin = [
  VideoScreen(),
  BookmarkVideoScreen(),
  //SearchScreen(),
  // const AddVideoScreen(),
  const Center(child: Text('Messages Screen')),
  ProfileScreen(uid: authController.user.uid),
];

//COLORS
const backgroundColor = Colors.black;
var buttonColor = Colors.red[400];
const borderColor = Colors.grey;

//FIREBASE
var firebaseAuth = FirebaseAuth.instance;
var firebaseStorage = FirebaseStorage.instance;
var firestore = FirebaseFirestore.instance;

//CONTROLLER
var authController = AuthController.instance;


