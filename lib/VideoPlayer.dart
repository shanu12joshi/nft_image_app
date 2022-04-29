import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:nft_app/widget/customtitle/customtitletext.dart';
import 'package:video_player/video_player.dart';

class NFTVideoPlayer extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;
  final String url;
  final String? role;

  const NFTVideoPlayer(this.documentSnapshot,this.url, this.role);

  @override
  _NFTVideoPlayerState createState() => _NFTVideoPlayerState();
}

class _NFTVideoPlayerState extends State<NFTVideoPlayer> {
  late VideoPlayerController _controller;
  bool doesExists = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        setState(() {});
      });
    _controller.play();
  }

  @override
  Future<bool> doesIdAlreadyExists(String? docId) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('selectedArt')
        .where('id', isEqualTo: docId)
        .limit(1)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    return documents.length == 1;
  }

  Widget build(BuildContext context) {
    doesIdAlreadyExists(widget.documentSnapshot.id).then((value) {
      setState(() {
        doesExists = value;
      });
    });
    return Scaffold(
      body: widget.role == "owner"
          ? Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: Center(
                child: _controller.value.isInitialized
                    ? Column(
                        children: [
                          CustomTitle(
                            fontSize: 30,
                            text: widget.documentSnapshot['title'],
                            color: Colors.black,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              elevation: 10,
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height / 1.5,
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
                                  text: widget.documentSnapshot['twitter'],
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : CircularProgressIndicator(),
              ),
            )
          : Center(
              child: _controller.value.isInitialized
                  ? Column(
                      children: [
                        CustomTitle(
                          fontSize: 30,
                          text: widget.documentSnapshot['title'],
                          color: Colors.black,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            elevation: 10,
                            child: Container(
                              height: MediaQuery.of(context).size.height / 1.5,
                              child: AspectRatio(
                                aspectRatio: _controller.value.aspectRatio,
                                child: VideoPlayer(_controller),
                              ),
                            ),
                          ),
                        ),
                        FloatingActionButton(
                          child: _controller.value.isPlaying
                              ? Icon(Icons.pause)
                              : Icon(Icons.play_arrow),
                          onPressed: () {
                            setState(() {
                              if (_controller.value.isPlaying)
                                _controller.pause();
                              else
                                _controller.play();
                            });
                          },
                        ),
                        widget.role == "curator"?
                        IconButton(
                            onPressed: (){
                              if (doesExists) {
                                FirebaseFirestore
                                    .instance.collection("selectedArt").doc(widget.documentSnapshot.id).delete();
                              }
                              else{
                                FirebaseFirestore.instance.collection('selectedArt').doc(widget.documentSnapshot.id).set({
                                  'title': widget.documentSnapshot["title"],
                                  'id': widget.documentSnapshot["id"],
                                  'description': widget.documentSnapshot["description"],
                                  'twitter':widget.documentSnapshot["twitter"],
                                  'images': widget.documentSnapshot["images"],
                                  "userid":widget.documentSnapshot["userid"],
                                  "type": widget.documentSnapshot["type"],
                                  "imageThumbnail": widget.documentSnapshot["imageThumbnail"],
                                });
                              }
                            }
                            ,icon: doesExists
                            ? Icon(Icons.heart_broken_rounded)
                            : Icon(Icons.print), color:doesExists? Colors.red:Colors.black,)
                            : SizedBox.shrink(),
                      ],
                    )
                  : CircularProgressIndicator(),
            ),
    );
  }
}
