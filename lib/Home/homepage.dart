import 'dart:async';
import 'dart:html';
import 'package:cupertino_stepper/cupertino_stepper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nft_app/Utils/authentication.dart';
import 'package:nft_app/Utils/nftuploadservice.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:path/path.dart' as Path;
import 'package:firebase/firebase.dart' as fb;
import 'package:firebase/firestore.dart' as fs;

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

  late String ImageURL;

  // fb.UploadTask? task;
  // Future<void> _handleSignOut() => _googleSignIn.signOut();
  // FirebaseService service = new FirebaseService();
  Future<bool?> data() async {
    final status = await SharedPreferences.getInstance();
    setState(() {
      nftuploaded = status.getBool("status");
    });
    print("NFT UPLOAD STATUS: ${nftuploaded}");
    return nftuploaded;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    data();
  }

  int _currentStep = 1;

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    print("USERS");
    print(user);
    return Scaffold(
      appBar: AppBar(
        // centerTitle: true,
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
        title:CustomTitle(
          fontSize: 30,
          text:  "THE UNBIASED",
          color: Colors.black,
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await signOutGoogle().then((result) {
                print(result);
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/signin', (route) => false);
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
      body: Form(
        key: _formkey,
        child: ListView(
          padding: EdgeInsets.all(10),
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    height: MediaQuery.of(context).size.height * 0.25,
                    child: Stepper(
                      type: StepperType.horizontal,
                      currentStep: _currentStep,
                      elevation: 0.0,
                      onStepCancel: () {
                        if (_currentStep > 0) {
                          setState(() {
                            _currentStep -= 1;
                          });
                        }
                      },
                      onStepContinue: () {
                        if (_currentStep <= 0) {
                          setState(() {
                            _currentStep += 1;
                          });
                        }
                      },
                      onStepTapped: (int index) {
                        setState(() {
                          _currentStep = index;
                        });
                      },
                      steps: <Step>[
                        Step(
                          title: const Text('Step 1 SignIn'),
                          content: Container(
                              alignment: Alignment.centerLeft,
                              child: const Text('Content for Step 1')),
                        ),
                        const Step(
                          title: Text('Step 2 Submit Your ArtWork'),
                          content: Text('Content for Step 2'),
                        ),
                        const Step(
                          title: Text('Step 3 Share On Twitter'),
                          content: Text('Content for Step 3'),
                        ),
                      ],
                    )),
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
                                      return "Please Enter Title";
                                    } else {
                                      return null;
                                    }
                                  },
                                  decoration: const InputDecoration(
                                      labelText: "Title",
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
                                text:"ART DESCRIPTION : ",
                                    fontSize: 18,
                              )),
                              Expanded(
                                flex: 5,
                                child: TextFormField(
                                  controller: descriptioncontroller,
                                  maxLines: 10,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Please Enter Your ArtWork Description";
                                    } else {
                                      return null;
                                    }
                                  },
                                  decoration: const InputDecoration(
                                      labelText: "Description",
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
                                      return "Please Enter Twitter Account ID";
                                    } else {
                                      return null;
                                    }
                                  },
                                  decoration: const InputDecoration(
                                      labelText: "Twitter",
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.all(20),
                                    primary: Colors.white),
                                onPressed: () {
                                  uploadStorage();
                                },
                                child: CustomTitle(
                                 text: 'UPLOAD YOUR ARTWORK',
                                      color: Colors.black,
                                ),
                              ),
                              // SizedBox(height: 30),
                              if (isVideo == true)
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.all(20),
                                      primary: Colors.white),
                                  onPressed: () {
                                    uploadThumbnailStorage();
                                  },
                                  child: Text(
                                    'UPLOAD YOUR THUMBNAIL IMAGE',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18),
                                  ),
                                )
                              else
                                Container(),
                            ],
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
                        child: nftuploaded == true
                            ? FutureBuilder(future: downloadURLS(ImageURL) ,builder: (context, image) {
                              print("HELLOOOOOOO");
                              print(image.data);
                              return Column(
                                children: [
                                  Image.network(
                                    image.data.toString(),
                                    fit: BoxFit.cover,
                                    width:
                                    MediaQuery.of(context).size.width / 3.5,
                                    // scale: 2.5,
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
                              );
                            } )
                            : TextButton(
                          onPressed: (){},
                              child: Container(
                                color: Colors.red,
                                width:
                                    MediaQuery.of(context).size.width / 3.5,
                          height: MediaQuery.of(context).size.height / 2.5,
                              ),
                            )),
                    // Expanded(
                    //   child: Row(
                    //     mainAxisSize: MainAxisSize.max,
                    //     children: [
                    //       Expanded(
                    //         flex: 3,
                    //         child: AbsorbPointer(
                    //           absorbing: true,
                    //           child: TextFormField(
                    //             controller: imagecontroller,
                    //             decoration: const InputDecoration(
                    //                 labelText: "Nft File",
                    //                 border: OutlineInputBorder(
                    //                     borderRadius: BorderRadius.all(
                    //                       Radius.circular(8),
                    //                     ),
                    //                     borderSide: BorderSide(
                    //                       color: Colors.black45,
                    //                     ))),
                    //           ),
                    //         ),
                    //       ),
                    //       SizedBox(
                    //         width: 10,
                    //       ),
                    //       Expanded(
                    //         child: Container(
                    //           height: 50,
                    //           child: ElevatedButton(
                    //               style: ElevatedButton.styleFrom(
                    //                   primary: Colors.green,
                    //                   shape: RoundedRectangleBorder(
                    //                       borderRadius:
                    //                       BorderRadius.all(Radius.circular(10)))),
                    //               onPressed: () {
                    //                 uploadStorage();
                    //
                    //                 // uploadImage();
                    //                 // uploadStorage();
                    //               },
                    //               child: Text("Upload")),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
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
            SizedBox(
              height: 10,
            ),
            StreamBuilder<fb.UploadTaskSnapshot>(
              stream: _uploadTask?.onStateChanged,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final event = snapshot.data;
                  double progress = event!.bytesTransferred / event.totalBytes;
                  final percentage = progress * 100;
                  print("%${percentage}");
                  return percentage == 100
                      ? SizedBox()
                      : AlertDialog(
                          title: Text("NFT Uploading Please Wait..."),
                          content: Center(
                            child: CircularProgressIndicator(
                              value: progress,
                            ),
                          ),
                          actions: [
                            Center(child: Text("${percentage.toDouble()}%"))
                          ],
                        );
                } else {
                  return SizedBox();
                }
              },
            ),
          ],
        ),
      ),
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
          print("DATA SUbmitetd");
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
              content: Text("NFT save successfully!"),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Text("Ok", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(primary: Colors.green),
                )
              ],
            );
          });
      // Navigator.pop(context);
    }
  }
}

Future<Uri> downloadURLS(String image) {
  print("IMAGE");
  print(image);
  print(fb
      .storage()
      .refFromURL("gs://nft-image-app.appspot.com/")
      .child(image)
      .getDownloadURL());
  return fb
      .storage()
      .refFromURL("gs://nft-image-app.appspot.com/")
      .child(image)
      .getDownloadURL();
}
