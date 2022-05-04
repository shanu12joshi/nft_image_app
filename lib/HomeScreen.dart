import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nft_app/Home/homepage.dart';
import 'package:nft_app/ImageView.dart';
import 'package:nft_app/VideoPlayer.dart';
import 'package:nft_app/widget/customsubtitle/customsubtitletext.dart';
import 'package:nft_app/widget/customtitle/customtitletext.dart';
import 'package:page_transition/page_transition.dart';

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
  String? role;
  User? user;
  bool? findUserOnce = false;
  bool isLoading = true;

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    super.initState();
  }

  Future<String> FindRole() async {
    final DocumentSnapshot result = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get();
    final String documents = result["role"];
    return documents;
  }

  Future<bool> doesNameAlreadyExist(String? name) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('nft')
        .where('userid', isEqualTo: name)
        .limit(1)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    return documents.length == 1;
  }

  Widget build(BuildContext context) {
    user = FirebaseAuth.instance.currentUser;
    if (findUserOnce == false) {
      FindRole().then((value) {
        if (mounted) {
          setState(() {
            role = value;
            findUserOnce = true;
          });
        }
      });
    }

    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 15,
              ),
              Image.network(
                "https://www.linkpicture.com/q/unbaised-1_2.png",
                height: MediaQuery.of(context).size.height / 14,
              ),
            ],
          ),
          backgroundColor: Colors.white,
          actions: [
            user == null
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 150, 0),
                    child: TextButton(
                      child: _isProcessing
                          ? Center(
                              child: CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                  Colors.blueGrey,
                                ),
                              ),
                            )
                          : CustomSubtitleTitle(
                              text: "SIGN IN",
                              fontSize: 20,
                              color: Colors.black,
                            ),
                      onPressed: () async {
                        setState(() {
                          _isProcessing = true;
                        });
                        await signInWithGoogle().then((result) {
                          if (result != null) {}
                        }).catchError((error) {
                          print('Registration Error: $error');
                        });
                        setState(() {
                          _isProcessing = false;
                        });
                      },
                    ),
                  )
                : Container(),
          ],
        ),
        body: LayoutBuilder(builder:
            (BuildContext context, BoxConstraints viewportConstraints) {
          // if (viewportConstraints.maxWidth > 1000) {
          return CustomScrollView(slivers: <Widget>[
            SliverList(
                delegate: SliverChildListDelegate(
              [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 6,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(200, 0, 200, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(children: [
                                    TextSpan(
                                        text: "BECOME A PART OF\nAN ",
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w200,
                                          color: Colors.black,
                                          fontSize: 45,
                                        )),
                                    TextSpan(
                                        text: "UNBIASED ",
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                            fontSize: 45)),
                                    TextSpan(
                                        text: "INITIATIVE",
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w200,
                                            color: Colors.black,
                                            fontSize: 45)),
                                  ]),
                                ),
                              ),
                              SizedBox(
                                height: 60,
                              ),
                              StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection("nft")
                                      .snapshots(),
                                  builder: (context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.hasData) {
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              CustomSubtitleTitle(
                                                text: "TOTAL SUBMISSION",
                                                fontSize: 15,
                                              ),
                                              SizedBox(height: 30),
                                              CustomTitle(
                                                text:
                                                    "${snapshot.data!.docs.length.toString()}",
                                                fontSize: 40,
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            width: 60,
                                          ),
                                          Container(
                                            color: Colors.black45,
                                            height: 100,
                                            width: 2,
                                          ),
                                          SizedBox(
                                            width: 60,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              CustomSubtitleTitle(
                                                text: "TOTAL PICKED",
                                                fontSize: 15,
                                              ),
                                              SizedBox(height: 30),
                                              CustomTitle(
                                                text: "100/100",
                                                fontSize: 40,
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    } else {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                  }),
                              SizedBox(
                                height: 80,
                              ),
                              user != null
                                  ? TextButton(
                                      style: ButtonStyle(
                                        alignment: Alignment.center,
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Color(0xFF4B4848)),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    HomePage()));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            60, 12, 60, 12),
                                        child: CustomTitle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w200,
                                          text: "SUBMIT YOUR ART HERE",
                                          fontSize: 18,
                                          letterspace: 5,
                                        ),
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                          StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection("nft")
                                  .orderBy("CreatedAt", descending: true)
                                  .limit(1)
                                  .snapshots(),
                              builder: (context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.hasData) {
                                  DocumentSnapshot doc = snapshot.data!.docs[0];
                                  bool type = getUrlType(doc["type"]);
                                  return FutureBuilder(
                                      future: type
                                          ? downloadURLS(doc["images"])
                                          : downloadURLS(doc["imageThumbnail"]),
                                      builder: (context, image) {
                                        if (image.data == null) {
                                          return SizedBox();
                                        }
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              right: 18.0),
                                          child: Container(
                                            color: Color(0xFF4B4848),
                                            child: Column(
                                              children: [
                                                Stack(
                                                  children: [
                                                    Container(
                                                      child: Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            3.75,
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height /
                                                            1.8,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                          fit: BoxFit.cover,
                                                          image: NetworkImage(
                                                            image.data
                                                                .toString(),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    // Image.network(
                                                    //   "${image.data}",
                                                    //   width:
                                                    //       MediaQuery.of(context)
                                                    //               .size
                                                    //               .width /
                                                    //           3.75,
                                                    // ),
                                                    Positioned(
                                                      left: 0,
                                                      bottom: 0,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 12,
                                                                bottom: 12,
                                                                left: 12),
                                                        child: Text(
                                                            "LAST UPLOADED",
                                                            style: GoogleFonts
                                                                .poppins(
                                                              color: Color(
                                                                  0xFFDFDFDF),
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            )),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  alignment: Alignment.center,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      3.75,
                                                  padding: EdgeInsets.fromLTRB(
                                                      6, 15, 6, 15),
                                                  color: Color(0xFF4B4848),
                                                  child: Text(
                                                    "${doc["title"].toString().toUpperCase()}",
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 20,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        letterSpacing: 2),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                } else {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 18.0),
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              }),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 6,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("nft")
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 180.0),
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              return new GridView.builder(
                                  shrinkWrap: true,
                                  physics: new NeverScrollableScrollPhysics(),
                                  itemCount: snapshot.data!.docs.length,
                                  scrollDirection: Axis.vertical,
                                  gridDelegate:
                                      new SliverGridDelegateWithFixedCrossAxisCount(
                                          childAspectRatio: 1 / 1.2,
                                          crossAxisCount: 3,
                                          crossAxisSpacing: 20,
                                          mainAxisSpacing: 20),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    DocumentSnapshot doc =
                                        snapshot.data!.docs[index];
                                    bool type = getUrlType(doc["type"]);
                                    String videoUrl = "";
                                    return FutureBuilder(
                                        future: type
                                            ? downloadURLS(doc["images"])
                                            : downloadURLS(
                                                doc["imageThumbnail"]),
                                        builder: (context, image) {
                                          if (type != true) {
                                            downloadURLS(doc["images"]).then(
                                                (value) => videoUrl =
                                                    value.toString());
                                          }
                                          return Card(
                                            child: InkWell(
                                              splashColor:
                                                  Colors.blue.withAlpha(30),
                                              onTap: () {
                                                if (type) {
                                                  Navigator.of(context).push(
                                                    PageTransition(
                                                        type: PageTransitionType
                                                            .scale,
                                                        alignment: Alignment
                                                            .bottomCenter,
                                                        child: ImageView(
                                                            doc,
                                                            image.data
                                                                .toString(),
                                                            role)),
                                                  );
                                                } else {
                                                  Navigator.of(context).push(
                                                    PageTransition(
                                                        type: PageTransitionType
                                                            .scale,
                                                        alignment: Alignment
                                                            .bottomCenter,
                                                        child: NFTVideoPlayer(
                                                            doc,
                                                            videoUrl,
                                                            role)),
                                                  );
                                                }
                                              },
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Stack(
                                                    alignment: Alignment.center,
                                                    children: [
                                                      Container(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height /
                                                            1.8,
                                                        decoration:
                                                            BoxDecoration(
                                                          // borderRadius:
                                                          //     BorderRadius.circular(10),
                                                          image:
                                                              DecorationImage(
                                                            fit: BoxFit.cover,
                                                            image: NetworkImage(
                                                              image.data
                                                                  .toString(),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      type
                                                          ? SizedBox.shrink()
                                                          : Center(
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              50),
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.25),
                                                                ),
                                                                child: Icon(
                                                                  Icons
                                                                      .play_arrow_rounded,
                                                                  size: 50,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                            ),
                                                    ],
                                                  ),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0,
                                                            top: 4.0,
                                                            right: 8.0),
                                                    color: Colors.black,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8.0,
                                                              top: 20,
                                                              right: 8.0),
                                                      child: Text(
                                                        "${doc["title"].toString().toUpperCase()}",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding:
                                                    const EdgeInsets.only(
                                                        left: 8.0,
                                                        top: 4.0,
                                                        right: 8.0),
                                                    color: Colors.black,
                                                    child: Padding(
                                                      padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0,
                                                          top: 20,
                                                          right: 8.0),
                                                      child: Text(
                                                        "${doc["CreatedAt"].toDate()}",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 18,
                                                            fontWeight:
                                                            FontWeight
                                                                .w600),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ),
                                                  role != "owner"
                                                      ? IconButton(
                                                    alignment: Alignment.bottomRight,
                                                        color: Colors.red,
                                                        onPressed: () {
                                                          FirebaseFirestore
                                                              .instance
                                                              .runTransaction(
                                                                  (transaction) async =>
                                                              await transaction.delete(doc.reference));
                                                        },
                                                        icon: Icon(
                                                          Icons.delete,size: 20,),
                                                      )
                                                      : SizedBox.shrink()
                                                ],
                                              ),
                                            ),
                                            color: Colors.black,
                                            elevation: 5,
                                          );
                                        });
                                  });
                            }
                          }),
                    ),
                  ],
                )
              ],
            ))
          ]);
          // }

          // else if (viewportConstraints.maxWidth > 600) {
          //   return CustomScrollView(slivers: <Widget>[
          //     SliverList(
          //         delegate: SliverChildListDelegate(
          //       [
          //         Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             Padding(
          //               padding: const EdgeInsets.only(bottom: 18.0),
          //               child: Row(
          //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                   children: [
          //                     Padding(
          //                       padding: const EdgeInsets.fromLTRB(30, 8, 8, 0),
          //                       child: CustomTitle(
          //                         fontSize: 30,
          //                         text: "THE UNBIASED",
          //                         color: Colors.black,
          //                       ),
          //                     ),
          //                     user == null
          //                         ? Padding(
          //                             padding: const EdgeInsets.fromLTRB(
          //                                 0, 0, 30, 0),
          //                             child: TextButton(
          //                               child: _isProcessing
          //                                   ? Center(
          //                                       child:
          //                                           CircularProgressIndicator(
          //                                         valueColor:
          //                                             new AlwaysStoppedAnimation<
          //                                                 Color>(
          //                                           Colors.blueGrey,
          //                                         ),
          //                                       ),
          //                                     )
          //                                   : CustomSubtitleTitle(
          //                                       text: "Sign In",
          //                                       fontSize: 20,
          //                                       color: Colors.black,
          //                                     ),
          //                               onPressed: () async {
          //                                 setState(() {
          //                                   _isProcessing = true;
          //                                 });
          //                                 await signInWithGoogle()
          //                                     .then((result) {
          //                                   if (result != null) {}
          //                                 }).catchError((error) {
          //                                   print('Registration Error: $error');
          //                                 });
          //                                 setState(() {
          //                                   _isProcessing = false;
          //                                 });
          //                               },
          //                             ),
          //                           )
          //                         : Container(),
          //                   ]),
          //             ),
          //             Padding(
          //               padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
          //               child: Row(
          //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                 crossAxisAlignment: CrossAxisAlignment.start,
          //                 children: [
          //                   Column(
          //                     crossAxisAlignment: CrossAxisAlignment.start,
          //                     children: [
          //                       SizedBox(
          //                         height: 50,
          //                       ),
          //                       Padding(
          //                         padding: const EdgeInsets.all(8.0),
          //                         child: CustomTitle(
          //                           text:
          //                               "BECOME A PART OF\nAN UNBIASED INITIATIVE",
          //                           fontSize: 40,
          //                           color: Colors.black,
          //                         ),
          //                       ),
          //                       //TODO Line not showing here
          //                       Container(
          //                         height: 5,
          //                         width: 200,
          //                         color: Colors.black,
          //                       ),
          //                       SizedBox(
          //                         height: 60,
          //                       ),
          //                       StreamBuilder(
          //                           stream: FirebaseFirestore.instance
          //                               .collection("nft")
          //                               .snapshots(),
          //                           builder: (context,
          //                               AsyncSnapshot<QuerySnapshot> snapshot) {
          //                             if (snapshot.hasData) {
          //                               return Row(
          //                                 mainAxisAlignment:
          //                                     MainAxisAlignment.spaceBetween,
          //                                 children: [
          //                                   Column(
          //                                     crossAxisAlignment:
          //                                         CrossAxisAlignment.start,
          //                                     children: [
          //                                       CustomTitle(
          //                                         text: "TOTAL SUBMISSION",
          //                                         fontSize: 15,
          //                                       ),
          //                                       CustomTitle(
          //                                         text:
          //                                             "${snapshot.data!.docs.length.toString()}",
          //                                         fontSize: 40,
          //                                       ),
          //                                     ],
          //                                   ),
          //                                   SizedBox(
          //                                     width: 60,
          //                                   ),
          //                                   Column(
          //                                     crossAxisAlignment:
          //                                         CrossAxisAlignment.start,
          //                                     children: [
          //                                       CustomTitle(
          //                                         text: "TOTAL SELECTED",
          //                                         fontSize: 15,
          //                                       ),
          //                                       CustomTitle(
          //                                         text: "100/100",
          //                                         fontSize: 40,
          //                                       ),
          //                                     ],
          //                                   ),
          //                                 ],
          //                               );
          //                             } else {
          //                               return Center(
          //                                 child: CircularProgressIndicator(),
          //                               );
          //                             }
          //                           }),
          //                       SizedBox(
          //                         height: 60,
          //                       ),
          //                       user != null
          //                           ? TextButton(
          //                               style: ButtonStyle(
          //                                 backgroundColor:
          //                                     MaterialStateProperty.all<Color>(
          //                                         Colors.black),
          //                               ),
          //                               onPressed: () {
          //                                 Navigator.push(
          //                                     context,
          //                                     MaterialPageRoute(
          //                                         builder: (context) =>
          //                                             HomePage()));
          //                               },
          //                               child: Padding(
          //                                 padding: const EdgeInsets.all(12.0),
          //                                 child: CustomTitle(
          //                                   color: Colors.white,
          //                                   text: "Submit Your Art Work",
          //                                   fontSize: 18,
          //                                 ),
          //                               ),
          //                             )
          //                           : Container(),
          //                       SizedBox(
          //                         height: 60,
          //                       ),
          //                     ],
          //                   ),
          //                   StreamBuilder(
          //                       stream: FirebaseFirestore.instance
          //                           .collection("nft")
          //                           .orderBy("CreatedAt", descending: true)
          //                           .limit(1)
          //                           .snapshots(),
          //                       builder: (context,
          //                           AsyncSnapshot<QuerySnapshot> snapshot) {
          //                         if (snapshot.hasData) {
          //                           DocumentSnapshot doc =
          //                               snapshot.data!.docs[0];
          //                           bool type = getUrlType(doc["type"]);
          //                           return FutureBuilder(
          //                               future: type
          //                                   ? downloadURLS(doc["images"])
          //                                   : downloadURLS(
          //                                       doc["imageThumbnail"]),
          //                               builder: (context, image) {
          //                                 if (image.data == null) {
          //                                   return SizedBox();
          //                                 }
          //                                 return Padding(
          //                                   padding: const EdgeInsets.only(
          //                                       right: 18.0),
          //                                   child: Container(
          //                                     color: Colors.black,
          //                                     child: Column(
          //                                       children: [
          //                                         Padding(
          //                                           padding:
          //                                               EdgeInsets.fromLTRB(
          //                                                   10, 50, 10, 10),
          //                                           child: Image.network(
          //                                             "${image.data}",
          //                                             width:
          //                                                 MediaQuery.of(context)
          //                                                         .size
          //                                                         .width /
          //                                                     3.5,
          //                                           ),
          //                                         ),
          //                                         Container(
          //                                           padding:
          //                                               EdgeInsets.fromLTRB(
          //                                                   0, 0, 0, 15),
          //                                           color: Colors.black,
          //                                           child: Column(
          //                                             children: [
          //                                               Text(
          //                                                 "LAST UPLOADED",
          //                                                 style: TextStyle(
          //                                                   decoration:
          //                                                       TextDecoration
          //                                                           .underline,
          //                                                   color: Colors.white,
          //                                                   fontSize: 8,
          //                                                   fontWeight:
          //                                                       FontWeight.w600,
          //                                                 ),
          //                                               ),
          //                                               Text(
          //                                                 "${doc["title"].toString().toUpperCase()}",
          //                                                 style: TextStyle(
          //                                                     color:
          //                                                         Colors.white,
          //                                                     fontSize: 18,
          //                                                     fontWeight:
          //                                                         FontWeight
          //                                                             .w600),
          //                                               ),
          //                                             ],
          //                                           ),
          //                                         )
          //                                       ],
          //                                     ),
          //                                   ),
          //                                 );
          //                               });
          //                         } else {
          //                           return Padding(
          //                             padding:
          //                                 const EdgeInsets.only(right: 18.0),
          //                             child: CircularProgressIndicator(),
          //                           );
          //                         }
          //                       }),
          //                 ],
          //               ),
          //             ),
          //             StreamBuilder(
          //                 stream: FirebaseFirestore.instance
          //                     .collection("nft")
          //                     .snapshots(),
          //                 builder: (BuildContext context,
          //                     AsyncSnapshot<QuerySnapshot> snapshot) {
          //                   if (!snapshot.hasData) {
          //                     return CircularProgressIndicator();
          //                   } else {
          //                     return new GridView.builder(
          //                         physics: new NeverScrollableScrollPhysics(),
          //                         itemCount: snapshot.data!.docs.length,
          //                         scrollDirection: Axis.vertical,
          //                         shrinkWrap: true,
          //                         gridDelegate:
          //                             new SliverGridDelegateWithFixedCrossAxisCount(
          //                                 crossAxisCount: 3),
          //                         itemBuilder:
          //                             (BuildContext context, int index) {
          //                           DocumentSnapshot doc =
          //                               snapshot.data!.docs[index];
          //                           bool type = getUrlType(doc["type"]);
          //                           String videoUrl = "";
          //                           return FutureBuilder(
          //                               future: type
          //                                   ? downloadURLS(doc["images"])
          //                                   : downloadURLS(
          //                                       doc["imageThumbnail"]),
          //                               builder: (context, image) {
          //                                 if (type != true) {
          //                                   downloadURLS(doc["images"]).then(
          //                                       (value) => videoUrl =
          //                                           value.toString());
          //                                 }
          //                                 return Card(
          //                                   elevation: 5,
          //                                   child: Container(
          //                                     width: 200,
          //                                     height: 200,
          //                                     child: Stack(
          //                                       children: [
          //                                         InkWell(
          //                                           splashColor: Colors.blue
          //                                               .withAlpha(30),
          //                                           onTap: () {
          //                                             if (type) {
          //                                               Navigator.of(context)
          //                                                   .push(
          //                                                 PageTransition(
          //                                                     type:
          //                                                         PageTransitionType
          //                                                             .scale,
          //                                                     alignment: Alignment
          //                                                         .bottomCenter,
          //                                                     child: ImageView(
          //                                                         doc,
          //                                                         image.data
          //                                                             .toString(),
          //                                                         role)),
          //                                               );
          //                                             } else {
          //                                               Navigator.of(context)
          //                                                   .push(
          //                                                 PageTransition(
          //                                                     type:
          //                                                         PageTransitionType
          //                                                             .scale,
          //                                                     alignment: Alignment
          //                                                         .bottomCenter,
          //                                                     child:
          //                                                         NFTVideoPlayer(
          //                                                             doc,
          //                                                             videoUrl,
          //                                                             role)),
          //                                               );
          //                                             }
          //                                           },
          //                                           child: Center(
          //                                             child: type
          //                                                 ? Image.network(
          //                                                     image.data
          //                                                         .toString(),
          //                                                   )
          //                                                 : Stack(
          //                                                     children: [
          //                                                       Image.network(
          //                                                         image.data
          //                                                             .toString(),
          //                                                       ),
          //                                                       Center(
          //                                                         child:
          //                                                             Container(
          //                                                           decoration:
          //                                                               BoxDecoration(
          //                                                             color: Colors
          //                                                                 .black
          //                                                                 .withOpacity(
          //                                                                     0.25),
          //                                                             // border color
          //                                                             shape: BoxShape
          //                                                                 .circle,
          //                                                           ),
          //                                                           child: Icon(
          //                                                             Icons
          //                                                                 .play_arrow_rounded,
          //                                                             size: 50,
          //                                                             color: Colors
          //                                                                 .white,
          //                                                           ),
          //                                                         ),
          //                                                       )
          //                                                     ],
          //                                                   ),
          //                                           ),
          //                                         ),
          //                                       ],
          //                                     ),
          //                                   ),
          //                                 );
          //                               });
          //                         });
          //                   }
          //                 }),
          //           ],
          //         ),
          //       ],
          //     ))
          //   ]);
          // } else {
          //   return CustomScrollView(slivers: <Widget>[
          //     SliverList(
          //         delegate: SliverChildListDelegate(
          //       [
          //         Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             Row(
          //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                 children: [
          //                   Padding(
          //                     padding: const EdgeInsets.fromLTRB(10, 8, 8, 0),
          //                     child: CustomTitle(
          //                       fontSize: 20,
          //                       text: "THE UNBIASED",
          //                       color: Colors.black,
          //                     ),
          //                   ),
          //                   user == null
          //                       ? Padding(
          //                           padding:
          //                               const EdgeInsets.fromLTRB(0, 0, 8, 0),
          //                           child: TextButton(
          //                             child: _isProcessing
          //                                 ? Center(
          //                                     child: CircularProgressIndicator(
          //                                       valueColor:
          //                                           new AlwaysStoppedAnimation<
          //                                               Color>(
          //                                         Colors.blueGrey,
          //                                       ),
          //                                     ),
          //                                   )
          //                                 : CustomSubtitleTitle(
          //                                     text: "Sign In",
          //                                     fontSize: 15,
          //                                     color: Colors.black,
          //                                   ),
          //                             onPressed: () async {
          //                               setState(() {
          //                                 _isProcessing = true;
          //                               });
          //                               await signInWithGoogle().then((result) {
          //                                 if (result != null) {
          //                                   // Navigator.of(context).push(
          //                                   // MaterialPageRoute(
          //                                   //     builder: (context) =>
          //                                   //         ABC()));
          //                                   // Navigator.of(context).pushNamedAndRemoveUntil('/homepage', (route) => true);
          //                                 }
          //                               }).catchError((error) {
          //                                 print('Registration Error: $error');
          //                               });
          //                               setState(() {
          //                                 _isProcessing = false;
          //                               });
          //                             },
          //                           ),
          //                         )
          //                       : Container(),
          //                 ]),
          //             Padding(
          //               padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
          //               child: Row(
          //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                 crossAxisAlignment: CrossAxisAlignment.start,
          //                 children: [
          //                   Column(
          //                     crossAxisAlignment: CrossAxisAlignment.start,
          //                     children: [
          //                       SizedBox(
          //                         height: 30,
          //                       ),
          //                       Padding(
          //                         padding: const EdgeInsets.all(8.0),
          //                         child: CustomTitle(
          //                           text:
          //                               "BECOME A PART OF\nAN UNBIASED INITIATIVE",
          //                           fontSize: 30,
          //                           color: Colors.black,
          //                         ),
          //                       ),
          //                       //TODO Line not showing here
          //                       Padding(
          //                         padding: const EdgeInsets.all(8.0),
          //                         child: Container(
          //                           height: 3,
          //                           width: 200,
          //                           color: Colors.black,
          //                         ),
          //                       ),
          //                       SizedBox(
          //                         height: 60,
          //                       ),
          //                       StreamBuilder(
          //                           stream: FirebaseFirestore.instance
          //                               .collection("nft")
          //                               .snapshots(),
          //                           builder: (context,
          //                               AsyncSnapshot<QuerySnapshot> snapshot) {
          //                             if (snapshot.hasData) {
          //                               return Padding(
          //                                 padding: const EdgeInsets.fromLTRB(
          //                                     10, 0, 0, 0),
          //                                 child: Row(
          //                                   mainAxisAlignment:
          //                                       MainAxisAlignment.spaceBetween,
          //                                   children: [
          //                                     Column(
          //                                       crossAxisAlignment:
          //                                           CrossAxisAlignment.start,
          //                                       children: [
          //                                         CustomTitle(
          //                                           text: "TOTAL SUBMISSION",
          //                                           fontSize: 15,
          //                                         ),
          //                                         CustomTitle(
          //                                           text:
          //                                               "${snapshot.data!.docs.length.toString()}",
          //                                           fontSize: 25,
          //                                         ),
          //                                       ],
          //                                     ),
          //                                     SizedBox(
          //                                       width: 60,
          //                                     ),
          //                                     Column(
          //                                       crossAxisAlignment:
          //                                           CrossAxisAlignment.start,
          //                                       children: [
          //                                         CustomTitle(
          //                                           text: "TOTAL SELECTED",
          //                                           fontSize: 15,
          //                                         ),
          //                                         CustomTitle(
          //                                           text: "100/100",
          //                                           fontSize: 25,
          //                                         ),
          //                                       ],
          //                                     ),
          //                                   ],
          //                                 ),
          //                               );
          //                             } else {
          //                               return Center(
          //                                 child: CircularProgressIndicator(),
          //                               );
          //                             }
          //                           }),
          //                       SizedBox(
          //                         height: 60,
          //                       ),
          //                       user != null
          //                           ? Padding(
          //                               padding: const EdgeInsets.only(
          //                                 bottom: 40,
          //                               ),
          //                               child: TextButton(
          //                                 style: ButtonStyle(
          //                                   backgroundColor:
          //                                       MaterialStateProperty.all<
          //                                           Color>(Colors.black),
          //                                 ),
          //                                 onPressed: () {
          //                                   Navigator.push(
          //                                       context,
          //                                       MaterialPageRoute(
          //                                           builder: (context) =>
          //                                               HomePage()));
          //                                 },
          //                                 child: Padding(
          //                                   padding: const EdgeInsets.all(12.0),
          //                                   child: CustomTitle(
          //                                     color: Colors.white,
          //                                     text: "Submit Your Art Work",
          //                                     fontSize: 12,
          //                                   ),
          //                                 ),
          //                               ),
          //                             )
          //                           : Container(),
          //                       StreamBuilder(
          //                           stream: FirebaseFirestore.instance
          //                               .collection("nft")
          //                               .orderBy("CreatedAt", descending: true)
          //                               .limit(1)
          //                               .snapshots(),
          //                           builder: (context,
          //                               AsyncSnapshot<QuerySnapshot> snapshot) {
          //                             if (snapshot.hasData) {
          //                               DocumentSnapshot doc =
          //                                   snapshot.data!.docs[0];
          //                               bool type = getUrlType(doc["type"]);
          //                               return FutureBuilder(
          //                                   future: type
          //                                       ? downloadURLS(doc["images"])
          //                                       : downloadURLS(
          //                                           doc["imageThumbnail"]),
          //                                   builder: (context, image) {
          //                                     if (image.data == null) {
          //                                       return SizedBox();
          //                                     }
          //                                     return Container(
          //                                       color: Colors.black,
          //                                       child: Column(
          //                                         children: [
          //                                           Padding(
          //                                             padding:
          //                                                 EdgeInsets.fromLTRB(
          //                                                     10, 10, 10, 5),
          //                                             child: Image.network(
          //                                               "${image.data}",
          //                                               width: MediaQuery.of(
          //                                                           context)
          //                                                       .size
          //                                                       .width /
          //                                                   1.5,
          //                                             ),
          //                                           ),
          //                                           Container(
          //                                             padding:
          //                                                 EdgeInsets.fromLTRB(
          //                                                     0, 0, 0, 15),
          //                                             color: Colors.black,
          //                                             child: Column(
          //                                               children: [
          //                                                 Text(
          //                                                   "LAST UPLOADED",
          //                                                   style: TextStyle(
          //                                                     decoration:
          //                                                         TextDecoration
          //                                                             .underline,
          //                                                     color:
          //                                                         Colors.white,
          //                                                     fontSize: 8,
          //                                                     fontWeight:
          //                                                         FontWeight
          //                                                             .w600,
          //                                                   ),
          //                                                 ),
          //                                                 Text(
          //                                                   "${doc["title"].toString().toUpperCase()}",
          //                                                   style: TextStyle(
          //                                                       color: Colors
          //                                                           .white,
          //                                                       fontSize: 18,
          //                                                       fontWeight:
          //                                                           FontWeight
          //                                                               .w600),
          //                                                 ),
          //                                               ],
          //                                             ),
          //                                           )
          //                                         ],
          //                                       ),
          //                                     );
          //                                   });
          //                             } else {
          //                               return Padding(
          //                                 padding: const EdgeInsets.only(
          //                                     right: 18.0),
          //                                 child: CircularProgressIndicator(),
          //                               );
          //                             }
          //                           }),
          //                       SizedBox(
          //                         height: 60,
          //                       ),
          //                     ],
          //                   ),
          //                 ],
          //               ),
          //             ),
          //             StreamBuilder(
          //                 stream: FirebaseFirestore.instance
          //                     .collection("nft")
          //                     .snapshots(),
          //                 builder: (BuildContext context,
          //                     AsyncSnapshot<QuerySnapshot> snapshot) {
          //                   if (!snapshot.hasData) {
          //                     return CircularProgressIndicator();
          //                   } else {
          //                     return new GridView.builder(
          //                         physics: new NeverScrollableScrollPhysics(),
          //                         itemCount: snapshot.data!.docs.length,
          //                         scrollDirection: Axis.vertical,
          //                         shrinkWrap: true,
          //                         gridDelegate:
          //                             new SliverGridDelegateWithFixedCrossAxisCount(
          //                                 crossAxisCount: 2),
          //                         itemBuilder:
          //                             (BuildContext context, int index) {
          //                           DocumentSnapshot doc =
          //                               snapshot.data!.docs[index];
          //                           bool type = getUrlType(doc["type"]);
          //                           String videoUrl = "";
          //                           return FutureBuilder(
          //                               future: type
          //                                   ? downloadURLS(doc["images"])
          //                                   : downloadURLS(
          //                                       doc["imageThumbnail"]),
          //                               builder: (context, image) {
          //                                 if (type != true) {
          //                                   downloadURLS(doc["images"]).then(
          //                                       (value) => videoUrl =
          //                                           value.toString());
          //                                 }
          //                                 if (!type) {
          //                                   // _controller = VideoPlayerController.network(
          //                                   //     image.data.toString())
          //                                   //   ..initialize().then((_) {
          //                                   //     setState(() {});
          //                                   //   });
          //                                 }
          //                                 // if (snapshot.connectionState ==
          //                                 //     ConnectionState.done) {
          //                                 return Card(
          //                                   // shape: RoundedRectangleBorder(
          //                                   //   borderRadius: BorderRadius.circular(20),
          //                                   //   // if you need this
          //                                   //   side: BorderSide(
          //                                   //     color: Colors.grey.withOpacity(0.2),
          //                                   //     width: 1,
          //                                   //   ),
          //                                   // ),
          //                                   elevation: 5,
          //                                   child: Container(
          //                                     width: 200,
          //                                     height: 200,
          //                                     child: Stack(
          //                                       children: [
          //                                         InkWell(
          //                                           splashColor: Colors.blue
          //                                               .withAlpha(30),
          //                                           onTap: () {
          //                                             if (type) {
          //                                               Navigator.of(context)
          //                                                   .push(
          //                                                 PageTransition(
          //                                                     type:
          //                                                         PageTransitionType
          //                                                             .scale,
          //                                                     alignment: Alignment
          //                                                         .bottomCenter,
          //                                                     child: ImageView(
          //                                                         doc,
          //                                                         image.data
          //                                                             .toString(),
          //                                                         role)),
          //                                               );
          //                                             } else {
          //                                               Navigator.of(context)
          //                                                   .push(
          //                                                 PageTransition(
          //                                                     type:
          //                                                         PageTransitionType
          //                                                             .scale,
          //                                                     alignment: Alignment
          //                                                         .bottomCenter,
          //                                                     child:
          //                                                         NFTVideoPlayer(
          //                                                             doc,
          //                                                             videoUrl,
          //                                                             role)),
          //                                               );
          //                                             }
          //                                           },
          //                                           child: Center(
          //                                             child: type
          //                                                 ? Image.network(
          //                                                     image.data
          //                                                         .toString(),
          //                                                   )
          //                                                 : Stack(
          //                                                     children: [
          //                                                       Image.network(
          //                                                         image.data
          //                                                             .toString(),
          //                                                       ),
          //                                                       Center(
          //                                                         child:
          //                                                             Container(
          //                                                           decoration:
          //                                                               BoxDecoration(
          //                                                             color: Colors
          //                                                                 .black
          //                                                                 .withOpacity(
          //                                                                     0.25),
          //                                                             // border color
          //                                                             shape: BoxShape
          //                                                                 .circle,
          //                                                           ),
          //                                                           child: Icon(
          //                                                             Icons
          //                                                                 .play_arrow_rounded,
          //                                                             size: 50,
          //                                                             color: Colors
          //                                                                 .white,
          //                                                           ),
          //                                                         ),
          //                                                       )
          //                                                     ],
          //                                                   ),
          //                                           ),
          //                                         ),
          //                                       ],
          //                                     ),
          //                                   ),
          //                                 );
          //                               });
          //                         });
          //                   }
          //                 }),
          //           ],
          //         ),
          //       ],
          //     ))
          //   ]);
          // }
        }));

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
