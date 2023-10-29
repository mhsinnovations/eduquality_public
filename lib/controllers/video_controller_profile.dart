import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:eduquality/app_pref.dart';
import 'package:eduquality/models/video.dart';

import '../constants.dart';

class VideoControllerProfile extends GetxController {
  final Rx<List<Video>> videoFileList = Rx<List<Video>>([]);
  List<Video> get clickedVideoFile => videoFileList.value;

  final Rx<String> _clickedVideoID= "".obs;
  String get clickedVideoID => _clickedVideoID.value;

  //SET THE PRIVATE VIDEOID THAT WE WANT TO GET
  setVideoID(String vID) {
  _clickedVideoID.value= vID;
  }


  getClickedVideoInfo() {
    //GET ALL VIDEOS
    videoFileList.bindStream(
        FirebaseFirestore.instance
        .collection("videos")
        .snapshots()
        .map((QuerySnapshot snapshotQuery)
      {
        List<Video> videoList = [];

        for (var eachVideo in snapshotQuery.docs)
        {
          //COMPARE THE VIDEO'S ID TO THE CLICKED THUMBNAIL VIDEO ID
          if ( eachVideo["id"]== clickedVideoID)
          {
            videoList.add(
                Video.fromSnap(eachVideo)
              // THE FOLLOWING WAS IN THE LESSON..
              //Video.fromDocumentSnapshot(eachVideo)
            );
          }
        } // for

        return videoList;
      })
    ); //bindstream

}





  @override
  void onInit() {
    super.onInit();
    getClickedVideoInfo();

  }
  deleteVideo(String id, int index) async {
    try {
      await firestore.collection('videos').doc(id).delete();

      // _videoList.value.removeAt(index);
      videoFileList.refresh();
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
  }
}
