import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

// import 'package:firebase/firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart' as fb;

class HomeScreen extends StatefulWidget {
  static const route = '/homescreen';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String videoUrl =
      "https://firebasestorage.googleapis.com/v0/b/nft-image-app.appspot.com/o/NftFile%2F2022-03-26%2014%3A07%3A57.832?alt=media&token=0958e45f-ea77-4134-890b-8a32de43fa75";
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(videoUrl)
      ..initialize()
          .then((_) {
        setState(() {});
      });
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool isVideoPlayed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection("nft").snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Text("NO DATA");
              } else {
                return new GridView.builder(
                    itemCount: snapshot.data!.docs.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4),
                    itemBuilder: (BuildContext context, int index) {
                      DocumentSnapshot doc = snapshot.data!.docs[index];
                      bool type = getUrlType(doc["type"]);
                      print("type");
                      print(type);
                      return FutureBuilder(
                          future: type
                              ? downloadURLS(doc["images"])
                              : downloadURLS(doc["imageThumbnail"]),
                          builder: (context, image) {
                            if(type!=true){
                              downloadURLS(doc["images"]).then((value) =>
                              videoUrl = value.toString());
                              print(videoUrl);
                            }
                            if (!type) {
                              // _controller = VideoPlayerController.network(
                              //     image.data.toString())
                              //   ..initialize().then((_) {
                              //     setState(() {});
                              //   });
                            }
                            // if (snapshot.connectionState ==
                            //     ConnectionState.done) {
                            return Card(
                              // shape: RoundedRectangleBorder(
                              //   borderRadius: BorderRadius.circular(20),
                              //   // if you need this
                              //   side: BorderSide(
                              //     color: Colors.grey.withOpacity(0.2),
                              //     width: 1,
                              //   ),
                              // ),
                              elevation: 5,
                              child: Container(
                                width: 200,
                                height: 200,
                                child: Stack(
                                  children: [
                                    InkWell(
                                      splashColor: Colors.blue.withAlpha(30),
                                      // onTap: () {},
                                      child: Center(
                                          child: type
                                              ? Image.network(
                                                  image.data.toString(),
                                                )
                                              : Stack(
                                                  children: [
                                                    isVideoPlayed
                                                        ? AspectRatio(
                                                            aspectRatio:
                                                                _controller
                                                                    .value
                                                                    .aspectRatio,
                                                            child: VideoPlayer(
                                                                _controller),
                                                          )
                                                        : Image.network(
                                                            image.data
                                                                .toString(),
                                                          ),
                                                    Center(
                                                      child: InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            if (_controller
                                                                .value
                                                                .isPlaying) {
                                                              _controller
                                                                  .pause();
                                                            } else {
                                                              isVideoPlayed = true;
                                                              _controller = VideoPlayerController.network(videoUrl)
                                                                ..initialize()
                                                                    .then((_) {
                                                                  setState(() {});
                                                                });
                                                              _controller
                                                                  .play();
                                                            }
                                                          });
                                                        },
                                                        child: Icon(
                                                          _controller.value
                                                                  .isPlaying
                                                              ? Icons.pause
                                                              : Icons
                                                                  .play_arrow,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                )
                                          // : _controller.value.isInitialized
                                          //     ? AspectRatio(
                                          //         aspectRatio: _controller
                                          //             .value.aspectRatio,
                                          //         child:
                                          //             VideoPlayer(_controller),
                                          //       )
                                          //     : Container(),
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            );

                            // else {
                            //   return Text("LOADING");
                            // }
                          });
                    });
                // return new ListView.builder(
                //     itemCount: snapshot.data!.docs.length,
                //     itemBuilder: (context, index){
                //       DocumentSnapshot doc = snapshot.data!.docs[index];
                //
                //       // return Text(doc['title']);
                // });
              }
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Wrap the play or pause in a call to `setState`. This ensures the
            // correct icon is shown.
            setState(() {
              // If the video is playing, pause it.
              if (_controller.value.isPlaying) {
                _controller.pause();
              } else {
                // If the video is paused, play it.
                _controller.play();
              }
            });
          },
          // Display the correct icon depending on the state of the player.
          child: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ));
    // return GridView.count(
    //   crossAxisCount: 4,
    //   children: List.generate(100, (index) {
    //     return Center(
    //       child: Text(
    //         'Item $index',
    //         style: Theme.of(context).textTheme.headline5,
    //       ),
    //     );
    //   }),
    // );
  }

  Future<Uri> downloadURLS(String image) {
    return fb
        .storage()
        .refFromURL("gs://nft-image-app.appspot.com/")
        .child(image)
        .getDownloadURL();
  }

  bool getUrlType(String type) {
    if (type.contains("image")) {
      return true;
    }
    if (type.contains("video")) {
      return false;
    } else {
      print("jpeg");
      return true;
    }
  }

}
