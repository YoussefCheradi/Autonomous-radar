import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';


class VideoPlayerr extends StatefulWidget {
  const VideoPlayerr({super.key, required this.videoUrl});

  final String videoUrl;

  @override
  State<VideoPlayerr> createState() => _VideoPlayerState();

}

class _VideoPlayerState extends State<VideoPlayerr> {
  late VideoPlayerController controller;
  late Future<void> initializeVideo;

  @override
  void initState() {
    controller = VideoPlayerController.network(widget.videoUrl);
    initializeVideo = controller.initialize().then((_) {
      controller.play();
      controller.setLooping(true);
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: initializeVideo,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return AspectRatio(aspectRatio: controller.value.aspectRatio,
              child: VideoPlayer(controller),
            );
          }
          else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }
    );
  }
}
