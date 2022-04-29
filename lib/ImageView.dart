import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nft_app/widget/customtitle/customtitletext.dart';

class ImageView extends StatefulWidget {
  final DocumentSnapshot snapshot;
  final String imageURL;
  final String? role;

  const ImageView(this.snapshot, this.imageURL, this.role);

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {

  bool doesExists = false;

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
    doesIdAlreadyExists(widget.snapshot.id).then((value) {
      setState(() {
        doesExists = value;
      });
    });
    if (widget.role == "owner") {
      return Scaffold(
        body: SingleChildScrollView(
          child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery
                    .of(context)
                    .size
                    .height,
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 18.0),
                child: Center(
                  child: Column(
                    children: [
                      CustomTitle(
                        fontSize: 30,
                        text: widget.snapshot['title'],
                        color: Colors.black,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                            elevation: 10,
                            child: Image.network(
                              widget.imageURL,
                              height:
                              MediaQuery
                                  .of(context)
                                  .size
                                  .height / 1.25,
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
                              text: widget.snapshot['twitter'],
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
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
                text: widget.snapshot['title'],
                color: Colors.black,
              ),
              Card(
                //  shape: RoundedRectangleBorder(
                // borderRadius: BorderRadius.circular(15)),
                elevation: 10,
                child: Container(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height / 1.15,
                  child: Image.network(
                    widget.imageURL,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              widget.role == "curator"
                  ? //TODO CHANGE TO == Later
              IconButton(
                  onPressed: () {
                    if (doesExists) {
                      FirebaseFirestore
                          .instance.collection("selectedArt").doc(widget.snapshot.id).delete();
                    }
                    else {
                      FirebaseFirestore.instance
                          .collection('selectedArt')
                          .doc(widget.snapshot.id)
                          .set({
                        'title': widget.snapshot["title"],
                        'id': widget.snapshot["id"],
                        'description': widget.snapshot["description"],
                        'twitter': widget.snapshot["twitter"],
                        'images': widget.snapshot["images"],
                        "userid": widget.snapshot["userid"],
                        "type": widget.snapshot["type"],
                        "imageThumbnail": widget.snapshot["imageThumbnail"],
                      });
                    }
                  },
                  icon: doesExists
                      ? Icon(Icons.favorite)
                      : Icon(Icons.favorite_border_outlined), color:doesExists? Colors.red:Colors.black,)
                  : SizedBox.shrink(),
            ],
          ),
        ),
      );
    }
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
