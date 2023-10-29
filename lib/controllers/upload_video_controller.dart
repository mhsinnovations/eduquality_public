import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eduquality/models/video.dart';
import 'package:video_compress/video_compress.dart';

import '../constants.dart';

class UploadVideoController extends GetxController {
  _compressVideo(String videoPath) async {
    final compressedVideo = await VideoCompress.compressVideo(
      videoPath,
      quality: VideoQuality.MediumQuality,
      includeAudio: true,
    );
    return compressedVideo!.file;
  }

  Future<String> _uploadVideoToStorage(String id, String videoPath) async {
    Reference ref = firebaseStorage.ref().child('videos').child(id);
    var result = await _compressVideo(videoPath);
    print('prash path= $videoPath');
    UploadTask uploadTask = ref.putFile(result);
    print('prash compressd= ${result}');
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  _getThumbnail(String videoPath) async {
    final thumbnail = await VideoCompress.getFileThumbnail(videoPath);
    return thumbnail;
  }

  Future<String> _uploadImageToStorage(String id, String videoPath) async {
    Reference ref = firebaseStorage.ref().child('thumbnails').child(id);
    UploadTask uploadTask = ref.putFile(await _getThumbnail(videoPath));
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  //upload video
  uploadVideo(String songName, String caption, String videoPath) async {
    try {
      Get.dialog(
          Container(
            color: Colors.grey.withOpacity(0.2),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
          useSafeArea: false);
      String uid = firebaseAuth.currentUser!.uid;
      DocumentSnapshot userDoc =
          await firestore.collection('users').doc(uid).get();
      // get id
      var allDocs = await firestore.collection('videos').get();
      //var snapshot = await firestore.collection('videos').get();
      var myMap=allDocs.docs.asMap();
      // THIS CODE DOES NOT WORK BECAUSE THERE ARE DELETED IDS FROM THE DATABASE: int nextIdNum = allDocs.docs.length +1;


      // INSTEAD WILL CONVERT THE ID FROM STRING VAL AND LOOP TO FIND THE MAX
      // AT SOME POINT CHANGE ID IN THE DATABASE  TO BE INT NOT STRING
      // OR HAVE FIREBASE USE A SEQUENCE
        var MaxId =0;
        myMap.forEach((i, value) {
          print('index=$i, value=$value.data()');
          var id= int.parse(value.data()["id"]);
          if (id > MaxId) {
            MaxId =id;
          }
        });


      var nextIdNum=MaxId +1;
      String videoUrl = await _uploadVideoToStorage("$nextIdNum", videoPath);
      String thumbnail = await _uploadImageToStorage("$nextIdNum", videoPath);

      print('prash videoUrl= ${videoUrl}');
      print('prash thumbnail= ${thumbnail}');

      Video video = Video(
        username: (userDoc.data()! as Map<String, dynamic>)['name'],
        uid: uid,
        id: "$nextIdNum",
        userIdThatBookmarked: [],
        commentCount: 0,
        shareCount: 0,
        songName: songName,
        caption: caption,
        videoUrl: videoUrl,
        profilePhoto: (userDoc.data()! as Map<String, dynamic>)['profilePhoto'],
        thumbnail: thumbnail,
      );
      await firestore.collection('videos').doc('$nextIdNum').set(
            video.toJson(),
          );
      Get.back();
      Get.back();
    } catch (e) {
      Get.back();
      Get.snackbar(
        'Error Uploading Video',
        e.toString(),
      );
    }
  }
}
