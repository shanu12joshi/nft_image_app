import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase/firebase.dart'as fb;
import 'package:nft_app/Auth/signscreen.dart';
import 'package:nft_app/Utils/authentication.dart';
import 'package:nft_app/Utils/nftuploadservice.dart';
import 'package:shared_preferences/shared_preferences.dart';



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
  File? _img;

  String? title;
  String? des;
  String? twitter;
  File? Image;

  String? _imageurl;
  String error="";
  bool _loading = false;
  bool _imageselected = true;
  // Future<void> _handleSignOut() => _googleSignIn.signOut();
  // FirebaseService service = new FirebaseService();
@override
  void initState() {
    // TODO: implement initState
    super.initState();


  }
  @override
  Widget build(BuildContext context) {
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
    child: _loading==true?
    Center(
      child: CircularProgressIndicator(
        color: Colors.red,
      ),
    ):ListView(
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
                  }, child: Text("Upload")),
            ),)
          ],
        ),
        SizedBox(
          height: 50,
        ),
        Visibility(
         visible: _imageselected?false:true,
          child: Center(
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: _imageselected?Colors.grey:Colors.blue[200],
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
        )
      ],
    ),
  ),
    );
  }

  void uploadToCloud(){
    if(_formkey.currentState!.validate()){
        setState(() {
          _loading = true;
        });
        nftService.uploadNft(
          title: titlecontroller.text,
          description: descriptioncontroller.text,
          twitter: twittercontroller.text,
          userid: uid,
          image: _imageurl
        ).then((value) {
          setState(() {
            _loading = false;
            _formkey.currentState!.reset();
            twittercontroller.clear();
            titlecontroller.clear();
            descriptioncontroller.clear();
            imagecontroller.clear();
          });
        });
        showDialog(
            context: context,
            builder:(context){
              return AlertDialog(
                title: Text("NFT SAVE"),
                content: Text("NFT save successfully!"),
                actions: [
                  ElevatedButton(
                    onPressed: (){
                      Navigator.pop(context);
                    }, child:
                  Text("Ok",style:TextStyle(color: Colors.white)),
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


  Future<void> uploadImage(  {@required Function (File file)?selectedImage}) async {
    FileUploadInputElement uploadinput = FileUploadInputElement()..accept="image/*";
    // InputElement uploadinput = FileUploadInputElement()..accept="image/*";
    uploadinput.click();
    uploadinput.onChange.listen((event) {
      final files = uploadinput.files!.first;
      final reader = FileReader();
      reader.readAsDataUrl(files);
      reader.onLoadEnd.listen((event) {
        selectedImage!(files);
      });
    });

  }
  void uploadStorage(){
    //Upload to firebase storage
    final dateTime = DateTime.now();
    final path = "NftFile/$dateTime";
    uploadImage(selectedImage:(files){
      if(files!=null){
        setState(() {
          imagecontroller.text = files.name;
          _imageselected = false;
          _imageurl = path;
        });
        fb.storage().refFromURL("gs://nft-image-app.appspot.com").child(path).put(files);
      }
    });
  }
}
