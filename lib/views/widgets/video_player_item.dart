import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerItem({Key? key, required this.videoUrl}) : super(key: key);

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late CachedVideoPlayerController videoPlayerController;

  @override
  void initState() {
    super.initState();
    print('url: ${widget.videoUrl}');
    //var newUrl = 'https://firebasestorage.googleapis.com/v0/b/tiktok-clone-49b2d.appspot.com/o/videos%2FVideo%207.mp4?alt=media&token=fd65895b-86ce-4d45-a50a-ea7fc2211809';
    videoPlayerController = CachedVideoPlayerController.network(widget.videoUrl)
      ..initialize().then((value) {
        videoPlayerController.play();
        videoPlayerController.setVolume(1.0);
        videoPlayerController.setLooping(true);
      });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    videoPlayerController.pause();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      // onVerticalDragDown: (details) {
      //   videoPlayerController.pause();
      //   setState(() {});
      // },
      // onVerticalDragCancel: () {
      //   videoPlayerController.play();
      //   setState(() {});
      // },
      child: Container(
        width: size.width,
        height: size.height,
        decoration: const BoxDecoration(
          color: Colors.black,
        ),
        child: CachedVideoPlayer(videoPlayerController),
      ),
    );
  }
}
