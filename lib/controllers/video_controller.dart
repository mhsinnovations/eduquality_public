import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:eduquality/app_pref.dart';
import 'package:eduquality/models/video.dart';

import '../constants.dart';

class VideoController extends GetxController {
  final Rx<List<Video>> _videoList = Rx<List<Video>>([]);
  List<Video> get videoList => _videoList.value;
  final Rx<Map<String, dynamic>> _user = Rx<Map<String, dynamic>>({});
  Map<String, dynamic> get user => _user.value;

  Rx<int> role = 1.obs;

  @override
  void onInit() {
    super.onInit();
    _videoList.bindStream(
        firestore.collection('videos').snapshots().map((QuerySnapshot query) {
      List<Video> retVal = [];
      for (var element in query.docs) {
        retVal.add(Video.fromSnap(element));
      }
      return retVal;
    }));
  }

  getUserData() async {
    DocumentSnapshot userDoc = await firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    final userData = userDoc.data() ?? {} as dynamic;
    int role1 = userData['role'] ?? 1;
    await setPrefValue("Role", role1.toString());
    role.value = role1;
    update();
  }

  deleteVideo(String id, int index) async {
    try {
      await firestore.collection('videos').doc(id).delete();

      // _videoList.value.removeAt(index);
      _videoList.refresh();
      Get.snackbar(
        'Deleted',
        'Video Deleted Successfully',
      );
      //delete from user bookmarkVideos

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('users').get();

      WriteBatch batch = FirebaseFirestore.instance.batch();

      for (QueryDocumentSnapshot userSnapshot in querySnapshot.docs) {
        DocumentReference bookmarkVideoDocRef = FirebaseFirestore.instance
            .collection('users')
            .doc(userSnapshot.id)
            .collection('bookmarkVideos')
            .doc(id);

        batch.delete(bookmarkVideoDocRef);
      }

      await batch.commit();




    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
      );
    }
  }

  bookmarkVideo(String id) async {
    DocumentSnapshot doc = await firestore.collection('videos').doc(id).get();
    var uid = authController.user.uid;
    if ((doc.data()! as dynamic)['userIdThatBookmarked'].contains(uid)) {
      await firestore.collection('videos').doc(id).update({
        'userIdThatBookmarked': FieldValue.arrayRemove([uid])
      });
    } else {
      await firestore.collection('videos').doc(id).update({
        'userIdThatBookmarked': FieldValue.arrayUnion([uid])
      });
    }

    //code to create collection of bookmarkvideos for a user

    // Create a reference to the Firestore collection
    /*CollectionReference bookmarkVideosCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('bookmarkVideos');*/
    // Create a query to check if a document with the given uid and followersId exists
    /*QuerySnapshot querySnapshot = await bookmarkVideosCollection
        .where('id', isEqualTo: id)
        .limit(1)
        .get();*/

    DocumentSnapshot bookmarkVideoSnapshot =  await  FirebaseFirestore.instance
        .collection('users')
        .doc(authController.user.uid)
        .collection('bookmarkVideos')
        .doc(id)
        .get();



    // Check if any matching documents exist
    //if (querySnapshot.docs.isEmpty) {
    if (!bookmarkVideoSnapshot.exists) {
      //ADD IT
      await firestore
          .collection('users')
          .doc(authController.user.uid)
          .collection('bookmarkVideos')
          .doc(id)
          .set({});
    }else {
      await firestore
          .collection('users')
          .doc(authController.user.uid)
          .collection('bookmarkVideos')
          .doc(id)
          .delete();
    }



  }



}
