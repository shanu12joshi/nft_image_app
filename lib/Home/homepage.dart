import 'dart:async';
import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nft_app/Utils/authentication.dart';
import 'package:nft_app/Utils/nftuploadservice.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:url_launcher/url_launcher.dart';

import '../HomeScreen.dart';
import '../widget/customtitle/customtitletext.dart';

// flutter run -d chrome --web-hostname localhost --web-port 61992
//flutter run -d chrome --web-renderer html

class HomePage extends StatefulWidget {
  static const route = '/homepage';

  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  NftService nftService = NftService();
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController descriptioncontroller = TextEditingController();
  TextEditingController twittercontroller = TextEditingController();
  TextEditingController imagecontroller = TextEditingController();

  String? title;
  String? des;
  String? twitter;
  String? type;
  bool? isVideo;
  bool? isVideoThumbnailUploaded = true;

  String? _imageurl;
  String? _imageThumbnailurl = "";
  String error = "";
  bool _loading = false;
  bool _upload = false;
  bool _imageselected = true;
  double? progerss;
  fb.UploadTask? _uploadTask;
  bool? nftuploaded;
  bool? nftUploaded100 = false;

  String? ImageURL;
  String? ImageURLAfter100;

  final User? user = FirebaseAuth.instance.currentUser;

  // fb.UploadTask? task;
  // Future<void> _handleSignOut() => _googleSignIn.signOut();
  // FirebaseService service = new FirebaseService();

  Future<bool> doesNameAlreadyExist(String? name) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('nft')
        .where('userid', isEqualTo: name)
        .limit(1)
        .get();

    final List<DocumentSnapshot> documents = result.docs;
    return documents.length == 1;
  }

  @override
  Widget build(BuildContext context) {
    // print("OKAYYY");
    // Future<bool> i = doesNameAlreadyExist(user?.uid);
    // print(i);
    return Scaffold(
      appBar: AppBar(
        // centerTitle: true,
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Row(
          children: [
            Image.network(
              "https://www.linkpicture.com/q/unbaised-1_2.png",
              width: MediaQuery.of(context).size.width / 6,
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await signOutGoogle().then((result) {
                print(result);
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                    (Route<dynamic> route) => false);
                // Navigator.pop(context);
                // Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
              }).catchError((error) {
                print('Sign Out Error: $error');
              });
            },
            icon: Icon(
              Icons.login_outlined,
              color: Colors.black,
            ),
          )
        ],
      ),
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
        // doesNameAlreadyExist(user?.uid).then((value) {
        //   setState(() {
        //     nftuploaded = value;
        //   });
        // });
        //TODO Uncomment this part for not making user save nft twice
        if (viewportConstraints.maxWidth > 1000) {
          return Form(
            key: _formkey,
            child: ListView(
              padding: EdgeInsets.all(10),
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 9,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: CustomTitle(
                                      text: "ART TITLE : ",
                                      fontSize: 18,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: TextFormField(
                                      controller: titlecontroller,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Please Enter Art Title";
                                        } else {
                                          return null;
                                        }
                                      },
                                      decoration: const InputDecoration(
                                          labelText: "Art Title",
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                              borderSide: BorderSide(
                                                color: Colors.black45,
                                              ))),
                                      style: TextStyle(),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                      child: CustomTitle(
                                    text: "ART DESCRIPTION:",
                                    fontSize: 18,
                                  )),
                                  Expanded(
                                    flex: 5,
                                    child: TextFormField(
                                      controller: descriptioncontroller,
                                      maxLines: 10,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Please Enter Your Art Description";
                                        } else {
                                          return null;
                                        }
                                      },
                                      decoration: const InputDecoration(
                                          labelText: "Art Description",
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                              borderSide: BorderSide(
                                                color: Colors.black45,
                                              ))),
                                      style: TextStyle(),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                      child: CustomTitle(
                                    text: "TWITTER HANDLE : ",
                                    fontSize: 18,
                                  )),
                                  Expanded(
                                    flex: 5,
                                    child: TextFormField(
                                      controller: twittercontroller,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Please Enter Twitter Handle";
                                        } else {
                                          return null;
                                        }
                                      },
                                      decoration: const InputDecoration(
                                          labelText: "Twitter Handle",
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                              borderSide: BorderSide(
                                                color: Colors.black45,
                                              ))),
                                      style: TextStyle(),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 40,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                          // height: MediaQuery.of(context).size.height*0.5,
                          color: Colors.black,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Column(
                              children: [
                                StreamBuilder<fb.UploadTaskSnapshot>(
                                  stream: _uploadTask?.onStateChanged,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      final event = snapshot.data;
                                      double progress =
                                          event!.bytesTransferred /
                                              event.totalBytes;
                                      final percentage = progress * 100;
                                      if (percentage == 100) {
                                        if (isVideo == true &&
                                            isVideoThumbnailUploaded == true) {
                                          print("HWLLOOOO");
                                          downloadURLS(_imageThumbnailurl)
                                              .then((value) {
                                            if (mounted) {
                                              setState(() {
                                                nftUploaded100 = true;
                                                ImageURLAfter100 =
                                                    value.toString();
                                              });
                                            }
                                          });
                                        } else {
                                          downloadURLS(ImageURL).then((value) {
                                            if (mounted) {
                                              setState(() {
                                                nftUploaded100 = true;
                                                ImageURLAfter100 =
                                                    value.toString();
                                              });
                                            }
                                          });
                                        }
                                        if (isVideo == true &&
                                            isVideoThumbnailUploaded == false) {
                                          return TextButton(
                                            child: Image.network(
                                              "https://www.linkpicture.com/q/Thumbnail_5.png",
                                              fit: BoxFit.cover,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3.5,
                                              // scale: 2.5,
                                            ),
                                            // child: Image.network(
                                            //   "https://imageio.forbes.com/specials-images/imageserve/6170e01f8d7639b95a7f2eeb/Sotheby-s-NFT-Natively-Digital-1-2-sale-Bored-Ape-Yacht-Club--8817-by-Yuga-Labs/0x0.png?fit=bounds&format=png&width=960",
                                            //   fit: BoxFit.cover,
                                            //   width:
                                            //   MediaQuery.of(context).size.width /
                                            //       3.5,
                                            //   // scale: 2.5,
                                            // ),
                                            onPressed: () {
                                              uploadThumbnailStorage();
                                            },
                                          );
                                        } else if (isVideoThumbnailUploaded ==
                                            true) {
                                          if (ImageURLAfter100 != null) {
                                            return Image.network(
                                              "${ImageURLAfter100}",
                                              fit: BoxFit.cover,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3.5,
                                              // scale: 2.5,
                                            );
                                          } else {
                                            return Container(
                                              child:
                                                  CircularProgressIndicator(),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3.5,
                                            );
                                          }
                                        } else {
                                          if (ImageURLAfter100 != null) {
                                            return Image.network(
                                              "${ImageURLAfter100}",
                                              fit: BoxFit.cover,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3.5,
                                              // scale: 2.5,
                                            );
                                          } else {
                                            return Container(
                                              child:
                                                  CircularProgressIndicator(),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3.5,
                                            );
                                          }
                                        }
                                      } else {
                                        return AlertDialog(
                                          title: Text(
                                              "NFT Uploading Please Wait..."),
                                          content: Center(
                                            child: CircularProgressIndicator(
                                              value: progress,
                                            ),
                                          ),
                                          actions: [
                                            Center(
                                                child: Text(
                                                    "${percentage.toDouble()}%"))
                                          ],
                                        );
                                      }
                                    } else {
                                      return TextButton(
                                        child: Image.network(
                                          "https://www.linkpicture.com/q/NFT.png",
                                          fit: BoxFit.cover,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              3.5,
                                          // scale: 2.5,
                                        ),
                                        onPressed: () {
                                          uploadStorage();
                                        },
                                      );
                                    }
                                  },
                                ),
                                Container(
                                  // width: MediaQuery.of(context).size.width,
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(12),
                                  color: Colors.black,
                                  child: Text(
                                    "ART PREVIEW",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                nftuploaded == true
                    ? Text("Your Artwork is Already Submitted!")
                    : Text(''),
                SizedBox(
                  height: 50,
                ),
                if (nftuploaded != true)
                  if (isVideo == false || isVideoThumbnailUploaded == true)
                    Visibility(
                      visible: _upload,
                      child: Center(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.blue[200],
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)))),
                            onPressed: () {
                              if (_formkey.currentState!.validate()) {
                                setState(() {
                                  uploadToCloud();
                                });
                              }
                            },
                            child: Text("Save")),
                      ),
                    )
                  else
                    SizedBox(),
              ],
            ),
          );
        } else {
          return Form(
            key: _formkey,
            child: ListView(
              padding: EdgeInsets.only(top: 20, bottom: 10, left: 10, right: 10),
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTitle(
                            text: "ART TITLE:",
                            fontSize: 18,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: TextFormField(
                              controller: titlecontroller,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please Enter Art Title";
                                } else {
                                  return null;
                                }
                              },
                              decoration: const InputDecoration(
                                  labelText: "Art Title",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                      borderSide: BorderSide(
                                        color: Colors.black45,
                                      ))),
                              style: TextStyle(),
                            ),
                          ),
                          SizedBox(
                            height: 18,
                          ),
                          CustomTitle(
                            text: "ART DESCRIPTION:",
                            fontSize: 18,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: TextFormField(
                              controller: descriptioncontroller,
                              maxLines: 5,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please Enter Your Art Work Description";
                                } else {
                                  return null;
                                }
                              },
                              decoration: const InputDecoration(
                                  labelText: "Art Description",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                      borderSide: BorderSide(
                                        color: Colors.black45,
                                      ))),
                              style: TextStyle(),
                            ),
                          ),
                          SizedBox(
                            height: 18,
                          ),
                          CustomTitle(
                            text: "TWITTER HANDLE:",
                            fontSize: 18,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: TextFormField(
                              controller: twittercontroller,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please Enter Twitter Handle";
                                } else {
                                  return null;
                                }
                              },
                              decoration: const InputDecoration(
                                  labelText: "Twitter Handle",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                      borderSide: BorderSide(
                                        color: Colors.black45,
                                      ))),
                              style: TextStyle(),
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      // height: MediaQuery.of(context).size.height*0.5,
                      width: MediaQuery.of(context).size.width / 2,
                      color: Colors.black,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Column(
                          children: [
                            StreamBuilder<fb.UploadTaskSnapshot>(
                              stream: _uploadTask?.onStateChanged,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final event = snapshot.data;
                                  double progress = event!.bytesTransferred /
                                      event.totalBytes;
                                  final percentage = progress * 100;
                                  if (percentage == 100) {
                                    if (isVideo == true &&
                                        isVideoThumbnailUploaded == true) {
                                      downloadURLS(_imageThumbnailurl)
                                          .then((value) {
                                        if (mounted) {
                                          setState(() {
                                            nftUploaded100 = true;
                                            ImageURLAfter100 = value.toString();
                                          });
                                        }
                                      });
                                    } else {
                                      downloadURLS(ImageURL).then((value) {
                                        if (mounted) {
                                          setState(() {
                                            nftUploaded100 = true;
                                            ImageURLAfter100 = value.toString();
                                          });
                                        }
                                      });
                                    }
                                    if (isVideo == true &&
                                        isVideoThumbnailUploaded == false) {
                                      return TextButton(
                                        child: Image.network(
                                          "https://www.linkpicture.com/q/Thumbnail_5.png",
                                          fit: BoxFit.cover,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2.5,
                                          // scale: 2.5,
                                        ),
                                        onPressed: () {
                                          uploadThumbnailStorage();
                                        },
                                      );
                                    } else if (isVideoThumbnailUploaded ==
                                        true) {
                                      if (ImageURLAfter100 != null) {
                                        return Image.network(
                                          "${ImageURLAfter100}",
                                          fit: BoxFit.cover,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          // scale: 2.5,
                                        );
                                      } else {
                                        return Container(
                                          child: CircularProgressIndicator(),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              3.5,
                                        );
                                      }
                                    } else {
                                      if (ImageURLAfter100 != null) {
                                        return Image.network(
                                          "${ImageURLAfter100}",
                                          fit: BoxFit.cover,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          // scale: 2.5,
                                        );
                                      } else {
                                        return Container(
                                          child: CircularProgressIndicator(),
                                          width:
                                              MediaQuery.of(context).size.width,
                                        );
                                      }
                                    }
                                  } else {
                                    return AlertDialog(
                                      title:
                                          Text("NFT Uploading Please Wait..."),
                                      content: Center(
                                        child: CircularProgressIndicator(
                                          value: progress,
                                        ),
                                      ),
                                      actions: [
                                        Center(
                                            child: Text(
                                                "${percentage.toDouble()}%"))
                                      ],
                                    );
                                  }
                                } else {
                                  return TextButton(
                                    child: Image.network(
                                        "https://www.linkpicture.com/q/NFT.png",
                                        fit: BoxFit.cover,
                                        width: MediaQuery.of(context).size.width
                                        // scale: 2.5,
                                        ),
                                    onPressed: () {
                                      uploadStorage();
                                    },
                                  );
                                }
                              },
                            ),
                            Container(
                              // width: MediaQuery.of(context).size.width,
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(12),
                              color: Colors.black,
                              child: Text(
                                "ART PREVIEW",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                nftuploaded == true
                    ? Text("Your Artwork is Already Submitted!")
                    : Text(''),
                SizedBox(
                  height: 50,
                ),
                if (nftuploaded != true)
                  if (isVideo == false || isVideoThumbnailUploaded == true)
                    Visibility(
                      visible: _upload,
                      child: Center(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                            onPressed: () {
                              if (_formkey.currentState!.validate()) {
                                setState(() {
                                  uploadToCloud();
                                });
                              }
                            },
                            child: Text("Save")),
                      ),
                    )
                  else
                    SizedBox(),
              ],
            ),
          );
        }
      }),
    );
  }

  Future<void> uploadImage(
      {@required Function(File file)? selectedImage}) async {
    FileUploadInputElement uploadinput = FileUploadInputElement()
      ..accept = "image/*, video/*";
    // FileUploadInputElement uploadinput = FileUploadInputElement()..accept="image/*";
    uploadinput.click();
    uploadinput.onChange.listen((event) {
      final files = uploadinput.files!.first;
      final reader = FileReader();
      reader.readAsDataUrl(files);
      reader.onLoadEnd.listen((event) async {
        type = files.type;
        if (type!.contains("video")) {
          isVideoThumbnailUploaded = false;
          isVideo = true;
        }
        selectedImage!(files);
        _upload = true;
      });
    });
  }

  Future<void> uploadThumbnailImage(
      {@required Function(File file)? selectedImage}) async {
    FileUploadInputElement uploadinput = FileUploadInputElement()
      ..accept = "image/*";
    // FileUploadInputElement uploadinput = FileUploadInputElement()..accept="image/*";
    uploadinput.click();
    uploadinput.onChange.listen((event) {
      final files = uploadinput.files!.first;
      final reader = FileReader();
      reader.readAsDataUrl(files);
      reader.onLoadEnd.listen((event) async {
        isVideoThumbnailUploaded = true;
        selectedImage!(files);
        _upload = true;
      });
    });
  }

  void uploadStorage() {
    //Upload to firebase storage
    if (nftuploaded == false || nftuploaded == null) {
      final dateTime = DateTime.now();
      final path = "NftFile/$dateTime";
      ImageURL = path.toString();
      uploadImage(selectedImage: (files) {
        if (files != null) {
          setState(() {
            imagecontroller.text = files.name;
            _imageselected = false;
            _imageurl = path;
          });
          _uploadTask = fb
              .storage()
              .refFromURL("gs://nft-image-app.appspot.com")
              .child(path)
              .put(files);
        }
        print("_uploadTask");
        print(_uploadTask);
      });
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Your Artwork is Already Submitted!"),
              content: Text("Thank You !!"),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    _launchUrl();
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Text("Ok", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(primary: Colors.green),
                )
              ],
            );
          });
    }
  }

  void uploadThumbnailStorage() {
    //Upload to firebase storage
    if (nftuploaded == false ||
        nftuploaded == null ||
        isVideoThumbnailUploaded == false) {
      final dateTime = DateTime.now();
      final path = "NftFile/$dateTime";
      uploadThumbnailImage(selectedImage: (files) {
        if (files != null) {
          setState(() {
            imagecontroller.text = files.name;
            _imageselected = false;
            _imageThumbnailurl = path;
          });
          _uploadTask = fb
              .storage()
              .refFromURL("gs://nft-image-app.appspot.com")
              .child(path)
              .put(files);
        }
      });
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Your Artwork is Already Submitted!"),
              content: Text("Thank You !!"),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    _launchUrl();
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Text("Ok", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(primary: Colors.green),
                )
              ],
            );
          });
    }
  }

  void uploadToCloud({String? url}) async {
    if (_formkey.currentState!.validate()) {
      if (_imageurl != null) {
        setState(() {
          _loading = true;
        });
        nftService
            .uploadNft(
                title: titlecontroller.text,
                description: descriptioncontroller.text,
                twitter: twittercontroller.text,
                userid: uid,
                image: _imageurl,
                type: type,
                imageThumbnail: _imageThumbnailurl)
            .then((value) {
          setState(() {
            // pref.setBool("status", true);
            _loading = false;
            _formkey.currentState!.reset();
            twittercontroller.clear();
            titlecontroller.clear();
            descriptioncontroller.clear();
            imagecontroller.clear();
          });
        });
      } else {
        Fluttertoast.showToast(msg: "Please Select Your Artwork");
      }
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("NFT SAVE"),
              content: Text("NFT saved successfully!"),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    _launchUrl();
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Text("Submit", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(primary: Colors.green),
                )
              ],
            );
          });
      // Navigator.pop(context);
    }
  }
}


void _launchUrl() async {
  print("HELLOOOO");
  final Uri _url = Uri.parse('https://twitter.com/intent/tweet?text=I am verifying that I have submitted my art to THE UNBIASED #theunbiased #theunbiasedproject #nft #nfts');
  if (!await launchUrl(_url)) throw 'Could not launch $_url';
}

Future<Uri> downloadURLS(String? image) {
  return fb
      .storage()
      .refFromURL("gs://nft-image-app.appspot.com/")
      .child(image!)
      .getDownloadURL();
}
