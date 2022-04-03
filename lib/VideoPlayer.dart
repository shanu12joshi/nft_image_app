import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class NFTVideoPlayer extends StatefulWidget {
  final String url;

  const NFTVideoPlayer(this.url);

  @override
  _NFTVideoPlayerState createState() => _NFTVideoPlayerState();
}

class _NFTVideoPlayerState extends State<NFTVideoPlayer> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        setState(() {});
      });
    _controller.play();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : CircularProgressIndicator(),
          ),
          // Center(
          //   child: InkWell(
          //     child: Icon(
          //       _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          //       size: 60.0,
          //     ),
          //     onTap: (){
          //       setState(() {
          //         _controller.value.isPlaying
          //             ? _controller.pause()
          //             : _controller.play();
          //       });
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}
