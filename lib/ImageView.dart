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
    return Scaffold(
      body: SingleChildScrollView(
        child: ConstrainedBox(
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
                          elevation: 10,
                          child: Image.network(
                            widget.imageURL,
                            height:
                            MediaQuery.of(context).size.height / 1.25,
                          )),
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
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
