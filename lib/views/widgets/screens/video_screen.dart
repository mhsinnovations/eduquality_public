import 'package:flutter/material.dart';
import 'package:eduquality/app_pref.dart';
import '../../../constants.dart';
import '../../../controllers/video_controller.dart';
import '../circle_animation.dart';
import '../video_player_item.dart';
import 'package:get/get.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({Key? key}) : super(key: key);

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  final VideoController videoController = Get.put(VideoController());
  @override
  void initState() {
    super.initState();
    videoController.getUserData();
  }

  buildProfile(String profilePhoto) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Stack(
        children: [
          Positioned(
            left: 5,
            child: Container(
              width: 50,
              height: 50,
              padding: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image(
                    image: NetworkImage(profilePhoto),
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        "assets/broken_image.jpg",
                        fit: BoxFit.fitHeight,
                        // width: 160.0,
                        height: 122.0,
                      );
                    },
                    fit: BoxFit.cover),
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildMusicAlbum(String profilePhoto) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(11),
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.grey, Colors.white],
              ),
              borderRadius: BorderRadius.circular(25),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image(
                image: NetworkImage(profilePhoto),
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    "assets/broken_image.jpg",
                    fit: BoxFit.fitHeight,
                    // width: 160.0,
                    height: 122.0,
                  );
                },
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final uid=  authController.user.uid;

    return Scaffold(
      body: Obx(() {
        return PageView.builder(
          itemCount: videoController.videoList.length,
          controller: PageController(initialPage: 0, viewportFraction: 1),
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            final data = videoController.videoList[index];
            //print('prash my uid : $uid');
            //print('prash video data: ${data.username} ${data.uid}');
            return Stack(
              children: [
                VideoPlayerItem(
                  videoUrl: data.videoUrl,
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
                                    data.username,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    data.caption,
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
                                        data.songName,
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
                              Expanded( //USE EXPANDED TO FORCE THE BUTTONS TO THE BOTTOM
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end, // Align buttons to the bottom
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (getPrefValue("Role") == "0" && uid == data.uid)
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          InkWell(
                                            onTap: () => videoController.deleteVideo(data.id, index),
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
                                    if (getPrefValue("Role") != "3") //NOT A GUEST ALLOW BOOKMARKS
                                      if (data.userIdThatBookmarked.contains(uid))
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            InkWell(
                                              onTap: () => videoController.bookmarkVideo(data.id),
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
                                              onTap: () => videoController.bookmarkVideo(data.id),
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