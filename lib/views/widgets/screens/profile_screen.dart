import 'package:cached_network_image/cached_network_image.dart';
import 'package:eduquality/views/widgets/screens/video_player_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eduquality/constants.dart';
import 'package:eduquality/controllers/profile.controller.dart';
import 'package:eduquality/controllers/video_controller_profile.dart';
import 'package:eduquality/app_pref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileController profileController = Get.put(ProfileController());

  @override
  void initState() {
    super.initState();
    profileController.updateUserId(widget.uid);
  }


  readClickedThumbnailInfo (String clickedThumbnail) async
  {
    //NOT SURE WHY THE FOLLOWING DOES NOT WORK:
    //var allVideosDocs= FirebaseFirestore.instance.collection("videos").get();

    //INSTEAD NEED THIS:
    var allVideosDocs = await firestore
        .collection('videos')
        .get();

    for (int i=0; i<allVideosDocs.docs.length; i++)
    {
      if( ((allVideosDocs.docs[i].data() as dynamic )["thumbnail"]) == clickedThumbnail)
      {
        Get.to( () =>
          VideoPlayerProfileScreen(clickedVideoID:(allVideosDocs.docs[i].data() as dynamic)["id"] ),
        );
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
        init: ProfileController(),
        builder: (controller) {
          if (controller.user.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black12,

              // REMOVE THE PERSON ADD BUTTON AND THREE DOTS BUTTONS
              /*leading: const Icon(Icons.person_add_alt_1_outlined),
              actions: [
                // Icon(Icons.more_horiz),
                PopupMenuButton(
                  itemBuilder: (ctx) => [
                    // if (widget.uid == authController.user.uid)
                    //   _buildPopupMenuItem('Delete Account', () {
                    //     profileController.deleteProfile();
                    //   }),
                  ],
                )
              ],*/
              title: Text(
                controller.user['name'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Column(
                      children: [
                        //REMOVE CIRCLE PROFILE PICTURE ON PROFILE SCREEN
                        /*Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipOval(
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: controller.user['profilePhoto'],
                                height: 100,
                                width: 100,
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, error, stackTrace) {
                                  // printError();
                                  return Image.asset(
                                    "assets/broken_image.jpg",
                                    fit: BoxFit.fitHeight,
                                    // width: 160.0,
                                    height: 122.0,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),*/
                        const SizedBox(
                          height: 15,
                        ),
                       /*// REMOVE FOLLOWING, FOLLOWERS,LIKES  ETC FROM PROFILE SCREEN
                       Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Text(
                                  controller.user['following'],
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                const Text(
                                  'Following',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              color: Colors.black54,
                              width: 1,
                              height: 15,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 18,
                              ),
                            ),
                            Column(
                              children: [
                                Text(
                                  controller.user['followers'],
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                const Text(
                                  'Followers',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              color: Colors.black54,
                              width: 1,
                              height: 15,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                            ),
                            Column(
                              children: [
                                Text(
                                  controller.user['userIdThatBookmarked'],
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                const Text(
                                  'Likes',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),*/
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          // width: 140,
                          height: 47,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black12,
                            ),
                          ),

                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                InkWell(
                                  onTap: () {
                                    if (widget.uid == authController.user.uid) {
                                      authController.signOut();
                                    }
                                  },
                                  child: Text(
                                    /***** REMOVE FOLLOW UNFOLLOW
                                    widget.uid == authController.user.uid

                                        ? 'Sign Out'
                                        : controller.user['isFollowing']
                                        ? 'Unfollow'
                                        : 'Follow',
                                     */
                                    widget.uid == authController.user.uid ? 'Sign Out' : '',
                                      style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                                const SizedBox(
                                  width: 25,
                                ),
                                if ((widget.uid == authController.user.uid) &&  (getPrefValue("Role") != "3"))
                                  InkWell(
                                    onTap: () {
                                      profileController.deleteProfile();
                                    },
                                    child: const Text(
                                      'Delete Account',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                //added for bookmarkVideos

                              ],
                            ),
                          ),
                        ),
                        // video list
                        GridView.builder(
                          // BUILD THE PROFILE THUMBNAILS
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.user['thumbnails'].length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1,
                              crossAxisSpacing: 5,
                            ),
                            itemBuilder: (context, index) {
                              String thumbnail =
                                  controller.user['thumbnails'][index];



                              //ADD GESTUREDECTOR TO MAKE THE THUMBNAILS CLICKABLE
                              return GestureDetector(
                                onTap: ()
                                {
                                  readClickedThumbnailInfo(thumbnail);

                                },
                                child: Image.network(
                                  thumbnail,
                                  fit:BoxFit.cover,
                                ),
                              );
                            },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  PopupMenuItem _buildPopupMenuItem(String title, Function()? onTap) {
    return PopupMenuItem(
      height: 25,
      onTap: onTap,
      child: Text(
        title,
        style: TextStyle(fontSize: 14),
      ),
    );
  }
}
