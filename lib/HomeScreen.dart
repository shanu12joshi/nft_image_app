import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/rendering.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nft_app/ImageView.dart';
import 'package:nft_app/VideoPlayer.dart';
import 'package:video_player/video_player.dart';

// import 'package:firebase/firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart' as fb;

import 'Utils/authentication.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();

class HomeScreen extends StatefulWidget {
  static const route = '/homescreen';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override

  bool _isProcessing = false;


  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    bool isUserSignedIn = false;
    return Scaffold(body: LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
              constraints:
                  BoxConstraints(minHeight: viewportConstraints.maxHeight),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 8, 8, 0),
                        child: Text(
                          "THE UNBIASED",
                          style: TextStyle(
                            fontSize: 30,
                          ),
                        ),
                      ),
                      user == null? Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                        child: TextButton(
                          child:  _isProcessing?Center(
                              child: CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                  Colors.blueGrey,
                                ),
                              ),
                            )
                          : Text("Sign In",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                              )),
                          onPressed:()async{
                            setState(() {
                              _isProcessing = true;
                            });
                            await signInWithGoogle().then((result) {
                              if (result != null) {
                                // Navigator.of(context).push(
                                // MaterialPageRoute(
                                //     builder: (context) =>
                                //         ABC()));
                                Navigator.pop(context);
                                Navigator.of(context).pushNamedAndRemoveUntil('/homescreen', (route) => true);
                                // Navigator.of(context).pushNamedAndRemoveUntil('/homepage', (route) => true);
                              }
                            }).catchError((error) {
                              print('Registration Error: $error');
                            });
                            setState(() {
                              _isProcessing = false;
                            });

                          },
                        ),
                      ): Container(),
                  ]),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              height: 100,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "BECOME A PART OF\nAN UNBIASED INITIATIVE",
                                style: TextStyle(
                                  fontSize: 40,
                                ),
                              ),
                            ),
                            //TODO Line not showing here
                            Divider(
                              color: Colors.black,
                              height: 20,
                              thickness: 2,
                            ),
                            SizedBox(
                              height: 60,
                            ),
                            // Row(
                            //   // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     Text(
                            //       "TOTAL SUBMISSION",
                            //       style: TextStyle(
                            //         fontSize: 12,
                            //       ),
                            //     ),
                            //     Text(
                            //       "TOTAL SELECTED",
                            //       style: TextStyle(
                            //         fontSize: 12,
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            SizedBox(
                              height: 60,
                            ),
                            user!=null ? TextButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.black),
                              ),
                              onPressed: () {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    '/homepage', (route) => true);
                              },
                              child:Text(
                                "Submit Your Art Work",
                                style: TextStyle(color: Colors.white),
                              ),
                            ): Container(),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 50, 10, 10),
                          child: Image.network(
                            "https://f8n-production-collection-assets.imgix.net/0xe7a49073905c68153449472e054041638d0FF547/3/nft.png?q=80&auto=format%2Ccompress&cs=srgb&max-w=1680&max-h=1680",
                            width: 400,
                          ),
                        )
                      ],
                    ),
                  ),
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("nft")
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return Text("NO DATA");
                        } else {
                          return new GridView.builder(
                              itemCount: snapshot.data!.docs.length,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              gridDelegate:
                                  new SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 4),
                              itemBuilder: (BuildContext context, int index) {
                                DocumentSnapshot doc =
                                    snapshot.data!.docs[index];
                                bool type = getUrlType(doc["type"]);
                                String videoUrl = "";
                                return FutureBuilder(
                                    future: type
                                        ? downloadURLS(doc["images"])
                                        : downloadURLS(doc["imageThumbnail"]),
                                    builder: (context, image) {
                                      if (type != true) {
                                        downloadURLS(doc["images"]).then(
                                            (value) =>
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
                                                splashColor:
                                                    Colors.blue.withAlpha(30),
                                                onTap: () {
                                                  if (type) {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ImageView(image
                                                                  .data
                                                                  .toString())),
                                                    );
                                                  } else {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              NFTVideoPlayer(
                                                                  videoUrl)),
                                                    );
                                                  }
                                                },
                                                child: Center(
                                                  child: type
                                                      ? Image.network(
                                                          image.data.toString(),
                                                        )
                                                      : Stack(
                                                          children: [
                                                            Image.network(
                                                              image.data
                                                                  .toString(),
                                                            ),
                                                            Center(
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.25),
                                                                  // border color
                                                                  shape: BoxShape
                                                                      .circle,
                                                                ),
                                                                child: Icon(
                                                                  Icons
                                                                      .play_arrow_rounded,
                                                                  size: 50,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
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
                ],
              )),);
      },
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

