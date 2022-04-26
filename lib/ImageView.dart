import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nft_app/widget/customtitle/customtitletext.dart';

class ImageView extends StatefulWidget {
  final String imageURL;
  final String title;
  final String twitterHandel;
  final String? role;

  const ImageView(this.imageURL, this.title, this.twitterHandel, this.role);

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    if (widget.role == "owner") {
      return Scaffold(
        body: SingleChildScrollView(
          child: ConstrainedBox(
=======
    return Scaffold(
      body: SingleChildScrollView(
        child: ConstrainedBox(
>>>>>>> 4479d285e4bdb492ce2cb61a0a11cff93d0ba46a
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: widget.role == "owner"
                ? Padding(
                    padding: const EdgeInsets.only(top: 18.0),
                    child: Center(
                      child: Column(
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
                                child: Image.network(
                                  widget.imageURL,
                                  height:
                                      MediaQuery.of(context).size.height / 1.25,
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                CustomTitle(
                                  align: TextAlign.left,
                                  fontSize: 20,
                                  text: "By:",
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
                      ),
                    ),
                  )
                : Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Center(
                child: Column(
                  children: [
                    CustomTitle(
                      fontSize: 30,
                      text: widget.title,
                      color: Colors.black,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
<<<<<<< HEAD
                        // shape: RoundedRectangleBorder(
                        // borderRadius: BorderRadius.circular(50)),
                        elevation: 10,
                        child: Image.network(
                          widget.imageURL,
                          height: MediaQuery.of(context).size.height / 1.25,
                        ),
                      ),
=======
                          elevation: 10,
                          child: Image.network(
                            widget.imageURL,
                            height:
                            MediaQuery.of(context).size.height / 1.25,
                          )),
>>>>>>> 4479d285e4bdb492ce2cb61a0a11cff93d0ba46a
                    ),
                  ],
                ),
              ),
<<<<<<< HEAD
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        body: Center(
          child: Column(
            children: [
              CustomTitle(
                fontSize: 30,
                text: widget.title,
                color: Colors.black,
              ),
              Card(
                //  shape: RoundedRectangleBorder(
                // borderRadius: BorderRadius.circular(15)),
                elevation: 10,
                child: Container(
                  height: MediaQuery.of(context).size.height / 1.15,
                  width: MediaQuery.of(context).size.width / 2,
                  child: Image.network(
                    widget.imageURL,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
=======
            )),
      ),
    );
>>>>>>> 4479d285e4bdb492ce2cb61a0a11cff93d0ba46a
  }
}

// if (role != "owner") {
//   return Padding(
//     padding: const EdgeInsets.only(top: 18.0),
//     child: Center(
//         child: Column(
//       children: [
//         CustomTitle(
//           fontSize: 30,
//           text: widget.title,
//           color: Colors.black,
//         ),
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Card(
//               elevation: 10,
//               child: Image.network(widget.imageURL,
//                   height: MediaQuery.of(context).size.height)),
//         ),
//         Padding(
//           padding: const EdgeInsets.only(right: 12.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               CustomTitle(
//                 align: TextAlign.left,
//                 fontSize: 20,
//                 text: "By:",
//                 color: Colors.black,
//               ),
//               CustomTitle(
//                 align: TextAlign.right,
//                 fontSize: 20,
//                 text: widget.twitterHandel,
//                 color: Colors.black,
//               ),
//             ],
//           ),
//         ),
//       ],
//     )),
//   );
// } else {
//   return Card(
//     elevation: 10,
//     child: Image.network(
//       widget.imageURL,
//       height: MediaQuery.of(context).size.height,
//     ),
//   );
// }
