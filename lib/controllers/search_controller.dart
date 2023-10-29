import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:eduquality/constants.dart';
import '../models/user.dart';
import '../models/video.dart';

class SearchController extends GetxController {
  final Rx<List<User>> _searchedUsers = Rx<List<User>>([]);
  List<User> get searchedUsers => _searchedUsers.value;

  final Rx<List<Video>> _searchedVideos = Rx<List<Video>>([]);
  List<Video> get searchedVideos => _searchedVideos.value;



  searchUser(String typedUser) async {

    _searchedUsers.bindStream(
      firestore
          .collection('users')
          .where('name', isGreaterThanOrEqualTo: typedUser)
          .where('role', isEqualTo: 0)
          .snapshots()
          .map((QuerySnapshot query) {
        List<User> retVal = [];
        for(var elem in query.docs) {
          retVal.add(User.fromSnap(elem));
        }
        return retVal;
      }));
  }


  /** NOT USED YET
  searchVideo(String searchHashtag) async {
    _searchedVideos.bindStream(
        firestore
            .collection('video')
            //.where('SongName', isEqualTo: searchHashtag)
            .where('SongName', isGreaterThanOrEqualTo: searchHashtag)
            .where('SongName', isLessThanOrEqualTo: searchHashtag + '\uf8ff')
            .snapshots()
            .map((QuerySnapshot query) {
          List<Video> retVal = [];
          for(var elem in query.docs) {
            retVal.add(Video.fromSnap(elem));
          }
          return retVal;
        }));
  }***/
}