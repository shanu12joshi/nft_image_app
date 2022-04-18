import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nft_app/widget/customtitle/customtitletext.dart';
import 'package:video_player/video_player.dart';

class NFTVideoPlayer extends StatefulWidget {
  final String url;
  final String title;
  final String twitterHandel;

  const NFTVideoPlayer(this.url, this.title, this.twitterHandel);

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
  }

  Future<String> FindRole() async {
    final DocumentSnapshot result = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get();
    final String documents = result["role"];
    return documents;
    // return documents.length == 1;
  }

  Widget build(BuildContext context) {
    FindRole().then((value) {
      if (mounted) {
        setState(() {
          role = value;
        });
      }
    });
    if (role == "owner") {
      return Scaffold(
          body: Padding(
        padding: const EdgeInsets.only(top: 18.0),
        child: Center(
          child: _controller.value.isInitialized
              ? Column(
                  children: [
                    CustomTitle(
                      fontSize: 30,
                      text: widget.title,
                      color: Colors.black,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 10,
                        child: Container(
                          height: MediaQuery.of(context).size.height/1.25,
                          child: AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: VideoPlayer(_controller),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CustomTitle(
                            align: TextAlign.left,
                            fontSize: 20,
                            text: "By: @",
                            color: Colors.black,
                          ),
                          CustomTitle(
                            align: TextAlign.right,
                            fontSize: 20,
                            text: widget.twitterHandel,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : CircularProgressIndicator(),
        ),
      ));
    } else {
      return Center(
        child: _controller.value.isInitialized
            ? Card(
                elevation: 10,
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
              )
            : CircularProgressIndicator(),
      );
    }
  }
}
