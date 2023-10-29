import 'package:eduquality/controllers/video_controller_profile.dart';
import 'package:flutter/material.dart';
import 'package:eduquality/app_pref.dart';
import '../../../constants.dart';
import '../../../controllers/bookmarkVideo_controller.dart';
import '../circle_animation.dart';
import '../video_player_item.dart';
import 'package:get/get.dart';

class VideoPlayerProfileScreen extends StatefulWidget
{
 String clickedVideoID;
 VideoPlayerProfileScreen({required this.clickedVideoID,});
  @override
  State<VideoPlayerProfileScreen> createState() => _VideoPlayerProfileScreenState();
}

class _VideoPlayerProfileScreenState extends State<VideoPlayerProfileScreen> {
  //INIT OUR CONTROLLER
  final VideoControllerProfile controllerVideoProfile = Get.put(VideoControllerProfile());

  @override
  Widget build(BuildContext context) {

  controllerVideoProfile.setVideoID(widget.clickedVideoID.toString());


    final size = MediaQuery
        .of(context)
        .size;
    final uid = authController.user.uid;

    return Scaffold(
      appBar: AppBar(
      backgroundColor: Colors.black12,
        title: Text(
         "Swipe left to return",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Obx(() {
        return PageView.builder(

          itemCount: controllerVideoProfile.clickedVideoFile.length,
          controller: PageController(initialPage: 0, viewportFraction: 1),
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            final clickedVideoInfo = controllerVideoProfile.clickedVideoFile[index];
            return Stack(
              children: [
                //RECOMENDED WAY CustomVideoPlayer(videoFileUrl:eachVideoInfo.videoUrl.toString(),),
               //ORIGINAL WAY
                  VideoPlayerItem(
                  videoUrl: clickedVideoInfo.videoUrl,
                ),
                Column(
                  children: [
                    const SizedBox(
                      height: 100,
                    ),
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(
                                left: 20,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    clickedVideoInfo.username,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    clickedVideoInfo.caption,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.music_note,
                                        size: 15,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        clickedVideoInfo.songName,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),






                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ... (other widgets)
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end, // Align buttons to the bottom
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //DELETE BUTTON
                                    if (getPrefValue("Role") == "0" && (clickedVideoInfo.uid == uid))
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          InkWell(
                                            onTap: () => controllerVideoProfile.deleteVideo(clickedVideoInfo.id, index),
                                            child: const Icon(Icons.delete_forever, size: 40, color: Colors.white),
                                          ),
                                          const SizedBox(height: 7),
                                          const Text(
                                            "Delete",
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(height: 7),
                                        ],
                                      ),

                                    //BOOKMARK
                                    if (getPrefValue("Role") != "3") //DO NOT ALLOW  A GUEST USER TO BOOKMARK

                                      if (clickedVideoInfo.userIdThatBookmarked.contains(uid))
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            InkWell(
                                              onTap: () => controllerVideoProfile.bookmarkVideo(clickedVideoInfo.id),
                                              child: const Icon(Icons.bookmark, size: 40, color: Colors.red),
                                            ),
                                            Text(
                                              "bookmark",
                                              style: const TextStyle(
                                                fontSize: 20,
                                                color: Colors.white,
                                              ),
                                            ),
                                            const SizedBox(height: 7),
                                          ],
                                        )
                                      else
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            InkWell(
                                              onTap: () => controllerVideoProfile.bookmarkVideo(clickedVideoInfo.id),
                                              child: const Icon(Icons.bookmark, size: 40, color: Colors.white),
                                            ),
                                            Text(
                                              "bookmark",
                                              style: const TextStyle(
                                                fontSize: 20,
                                                color: Colors.white,
                                              ),
                                            ),
                                            const SizedBox(height: 7),
                                          ],
                                        ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      }),
    );
  }
}