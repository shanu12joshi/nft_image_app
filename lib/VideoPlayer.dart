import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  User? user;
  String? role;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        setState(() {});
      });
    _controller.play();
    // role = FindRole();
  }


  Future<String> FindRole() async {
    final DocumentSnapshot result = await FirebaseFirestore.instance
        .collection('users').doc(user?.uid).get();
    final String documents = result["role"];
    return documents;
    // return documents.length == 1;
  }

  Widget build(BuildContext context) {
    print("IUSER");
    print(user?.uid);

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
