import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eduquality/views/widgets/screens/auth/login_screen.dart';
import 'package:eduquality/models/video.dart';
import '../constants.dart';

class ProfileController extends GetxController {
  final Rx<Map<String, dynamic>> _user = Rx<Map<String, dynamic>>({});

  Map<String, dynamic> get user => _user.value;

  Rx<String> _uid = "".obs;

  updateUserId(String uid) {
    _uid.value = uid;
    getUserData();
  }

  getUserData() async {
    List<String> thumbnails = [];
    var myVideos = await firestore
        .collection('videos')
        .where('uid', isEqualTo: _uid.value)
        .get();

    print('prash my video = ${myVideos.docs.length}');
    for (int i = 0; i < myVideos.docs.length; i++) {
      thumbnails.add((myVideos.docs[i].data() as dynamic)['thumbnail']);
    }


    DocumentSnapshot userDoc =
    await firestore.collection('users').doc(_uid.value).get();
    final userData = userDoc.data() ?? {} as dynamic;
    String name = userData['name'] ?? "";
    print(userData['role'].toString());
    String profilePhoto = userData['profilePhoto'] ?? "";
    int userIdThatBookmarked = 0;
    int followers = 0;
    int following = 0;
    bool isFollowing = false;

    for (var item in myVideos.docs) {
      userIdThatBookmarked += (item.data()['userIdThatBookmarked'] as List).length;
    }


    //code for followers and following
    var followerDoc = await firestore
        .collection('users')
        .doc(_uid.value)
        .collection('followers')
        .get();
    var followingDoc = await firestore
        .collection('users')
        .doc(_uid.value)
        .collection('following')
        .get();
    followers = followerDoc.docs.length;
    following = followingDoc.docs.length;

    firestore
        .collection('users')
        .doc(_uid.value)
        .collection('followers')
        .doc(authController.user.uid)
        .get()
        .then((value) {
      if (value.exists) {
        isFollowing = true;
      } else {
        isFollowing = false;
      }
    });

    _user.value = {
      'followers': followers.toString(),
      'following': following.toString(),
      'isFollowing': isFollowing,
      'userIdThatBookmarked': userIdThatBookmarked.toString(),
      'profilePhoto': profilePhoto,
      'name': name,
      'thumbnails': thumbnails,
    };
    update();
  }

  followUser() async {


    /* if this is not my own profile,  update followers with that userID  and myID if it does not exist already*/


/*
    var doc = await firestore
        .collection('users')
        .doc(_uid.value)
        .collection('followers')
        .doc(authController.user.uid)
        .get();
    final userData = doc.data() ?? {} as dynamic;
*/


// Create a reference to the Firestore collection
    CollectionReference followersCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(_uid.value)
        .collection('followers');

// Create a query to check if a document with the given uid and followersId exists
    QuerySnapshot querySnapshot = await followersCollection
        .where('uid', isEqualTo: _uid.value)
        .where('followersId', isEqualTo: authController.user.uid)
        .limit(1)
        .get();

    // Check if any matching documents exist
    if (querySnapshot.docs.isEmpty) {
      await firestore
          .collection('users')
          .doc(_uid.value)
          .collection('followers')
          .doc(authController.user.uid)
          .set({});
      //.set(fol.toJson());
      await firestore
          .collection('users')
          .doc(authController.user.uid)
          .collection('following')
          .doc(_uid.value)
          .set({});
      //.set(fol.toJson());
      _user.value.update(
        'followers',
            (value) => (int.parse(value) + 1).toString(),
      );
    } else {
      await firestore
          .collection('users')
          .doc(_uid.value)
          .collection('followers')
          .doc(authController.user.uid)
          .delete();
      await firestore
          .collection('users')
          .doc(authController.user.uid)
          .collection('followering')
          .doc(_uid.value)
          .delete();
      _user.value.update(
        'followers',
            (value) => (int.parse(value) - 1).toString(),
      );
    }
    _user.value.update('isFollowing', (value) => !value);
    update();
  }

  deleteProfile() async {
    await Future.delayed(Duration(seconds: 0), () {});
    Get.dialog(AlertDialog(
      title: const Text("Alert!!"),
      content: const Text(
          "Sorry to see you go! Are you sure you want to delete your account?"),
      actions: [
        MaterialButton(
          child: const Text("No"),
          onPressed: () {
            Get.back();
          },
        ),
        MaterialButton(
          color: Colors.red,
          child: const Text(
            "Yes",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () async {
            Get.back();
            Get.dialog(Container(
              color: Colors.grey.withOpacity(0.2),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ));
            await deleteUserData();
            Get.offAll(LoginScreen());
          },
        ),
      ],
    ));
  }

  deleteUserData() async {
    var uid = firebaseAuth.currentUser!.uid;
    await firestore.collection('users').doc(uid).delete();
    firestore
        .collection('videos')
        .where("uid", isEqualTo: uid)
        .snapshots()
        .map((event) {
      for (var element in event.docs) {
        firestore.collection('videos').doc(element.id).delete();
      }
    });
    await firebaseAuth.currentUser!.delete();
  }

}






