import 'dart:async';
import 'dart:html';
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
// flutter run -d chrome --web-hostname localhost --web-port 61992
class HomePage extends StatefulWidget {
  static const route = '/homepage';


  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  NftService nftService = NftService();
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController descriptioncontroller = TextEditingController();
  TextEditingController twittercontroller = TextEditingController();
  TextEditingController imagecontroller = TextEditingController();


  String? title;
  String? des;
  String? twitter;

  String? _imageurl;
  String error="";
  bool _loading = false;
  bool _upload = false;
  bool _imageselected = true;
  double? progerss;
  fb.UploadTask? _uploadTask;
  bool? nftuploaded;
  // fb.UploadTask? task;
  // Future<void> _handleSignOut() => _googleSignIn.signOut();
  // FirebaseService service = new FirebaseService();
  Future<bool?> data ()async{
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
  @override
  Widget build(BuildContext context) {
    final fs.Firestore firestore = fb.firestore();

    return Scaffold(

         appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.deepOrange,
        title: Text("NFT Image App"),
        actions: [
          IconButton(
              onPressed:() async {
                    await signOutGoogle().then((result) {
                      print(result);
                      Navigator.of(context).pushNamedAndRemoveUntil('/signin', (route) => false);
                    }).catchError((error) {
                      print('Sign Out Error: $error');
                    }
                );
              },
              icon:Icon(Icons.login_outlined)
          )
        ],
      ),
         body: Form(
    key: _formkey,
    child: ListView(
      padding: EdgeInsets.all(10),
      children: [
        TextFormField(
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
        SizedBox(
          height: 10,
        ),
        TextFormField(
          controller: descriptioncontroller,
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
        SizedBox(
          height: 10,
        ),
        TextFormField(
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
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              flex: 3,
              child:AbsorbPointer(
                absorbing: true,
                child: TextFormField(
                controller: imagecontroller,
                decoration: const InputDecoration(
                    labelText: "Nft File",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                        borderSide: BorderSide(
                          color: Colors.black45,
                        ))),
                style: TextStyle(),
            ),
              ),),
            SizedBox(
              width: 10,
            ),
            Expanded(child: Container(
              height: 50,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))
                      )
                  ),
                  onPressed: (){

                    uploadStorage();

    // uploadImage();
                    // uploadStorage();
                  }, child: Text("Upload")),
            ),)
          ],
        ),
        nftuploaded==true?Text("Your Artwork is Already Submitted!"):Text(''),
        SizedBox(
          height: 50,
        ),
        nftuploaded!=true?
        Visibility(
         visible: _upload,
          child: Center(
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue[200],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))
                  )
                ),
                onPressed: (){
                  if(_formkey.currentState!.validate()){
                    setState(() {
                      uploadToCloud();
                    });
                    }
                }, child: Text("Save")),
          ),
        ):SizedBox(),
        SizedBox(
          height: 10,
        ),
        StreamBuilder<fb.UploadTaskSnapshot>(
          stream: _uploadTask?.onStateChanged,
          builder: (context, snapshot) {
            if(snapshot.hasData){
              final event = snapshot.data;
              double progress = event!.bytesTransferred / event.totalBytes;
              final percentage = progress * 100;
              print("%${percentage}");
              return percentage==100?SizedBox():AlertDialog(
                title: Text("NFT Uploading Please Wait..."),
                content: Center(
                  child:    CircularProgressIndicator(
                  ),
                ),
                actions: [
                  Center(child: Text("${percentage.toDouble()}%"))
                ],
              );
            }
           else{
               return SizedBox();
                  }

          },
        ),
      ],
    ),
  ),
    );
  }


  Future<void> uploadImage(  {@required Function (File file)?selectedImage}) async {
    FileUploadInputElement uploadinput = FileUploadInputElement()..accept="image/*";
    uploadinput.click();
    uploadinput.onChange.listen((event) {
      final files = uploadinput.files!.first;
      final reader = FileReader();
      reader.readAsDataUrl(files);
      reader.onLoadEnd.listen((event) async{
        selectedImage!(files);
        _upload = true;
      });
    });

  }

  void uploadStorage() {
    //Upload to firebase storage
    if(nftuploaded==false || nftuploaded==null){
      final dateTime = DateTime.now();
      final path = "NftFile/$dateTime";
      uploadImage(selectedImage: (files) {
        if (files != null) {
          setState(() {
            imagecontroller.text = files.name;
            _imageselected = false;
            _imageurl = path;
          }
          );
          _uploadTask =  fb.storage().refFromURL("gs://nft-image-app.appspot.com").child(path).put(files);
        }
      }
      );
    }
   else{
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
                  }, child:
                Text("Ok", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.green
                  ),
                )
              ],
            );
          }

      );
    }
  }

  void uploadToCloud({String? url})async {

    if (_formkey.currentState!.validate()) {
      if(_imageurl!=null){
        setState(() {
          _loading = true;
        });
        nftService.uploadNft(
          title: titlecontroller.text,
          description: descriptioncontroller.text,
          twitter: twittercontroller.text,
          userid: uid,
          image: _imageurl,
        ).then((value) {
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
      }
      else{
        Fluttertoast.showToast(msg:"Please Select Your Artwork");
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
                  }, child:
                Text("Ok", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.green
                  ),
                )
              ],
            );
          }

      );
      // Navigator.pop(context);
    }
  }

  }
