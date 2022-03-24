import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:shared_preferences/shared_preferences.dart';


import '../Utils/authentication.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
  ],
);
class SignScreen extends StatefulWidget {
  static const route = '/signin';

  @override
  State createState() => SignScreenState();
}

class SignScreenState extends State<SignScreen> {
  String _contactText = '';
  String url = "";
  String name = "";
  String mail ="";

  GoogleSignInAccount? _currentUser;
  SharedPreferences? sharedPreferences;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  // bool loading = false;
  // bool isloggedIn = false;

  bool _isProcessing = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? uid;
  String? userEmail;

  // Future<void> _handleSignIn() async  {
  //   // sharedPreferences = await SharedPreferences.getInstance();
  //   //
  //   //       setState(() {
  //   //           loading = true;
  //   //       });
  //   //       GoogleSignInAccount?  googleUser = await googleSignIn.signIn();
  //   //       GoogleSignInAuthentication googleSignInAuthentication = await googleUser!.authentication;
  //   //       User user = await firebaseAuth
  //
  //   try {
  //     await _googleSignIn.signIn().then((userData) {
  //       // setState(() {
  //       //   _currentUser = userData;
  //       //   url = userData!.photoUrl.toString();
  //       //   name = userData.displayName.toString();
  //       //   mail = userData.email.toString();
  //       // });
  //       if(userData!=null) {
  //          FirebaseFirestore.instance.collection("users").doc(userData.id).set({
  //                   "id":userData.id,
  //                   "gmail":userData.email,
  //                   "username":userData.displayName,
  //                   "profileUrl":userData.photoUrl
  //         });
  //       }
  //
  //       Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>HomePage()), (route) => false);
  //     });
  //   } catch (error) {
  //     print(error);
  //   }
  // }
  //
  // Future<User?> signInWithGoogle() async {
  //   // Initialize Firebase
  //   await Firebase.initializeApp();
  //   User? user;
  //
  //   // The `GoogleAuthProvider` can only be used while running on the web
  //   GoogleAuthProvider authProvider = GoogleAuthProvider();
  //
  //   try {
  //     final UserCredential userCredential = await _auth.signInWithPopup(authProvider);
  //
  //     user = userCredential.user;
  //   } catch (e) {
  //     print(e);
  //   }
  //
  //   if (user != null) {
  //     uid = user.uid;
  //     name = user.displayName.toString();
  //     userEmail = user.email;
  //     url = user.photoURL.toString();
  //
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     prefs.setBool('auth', true);
  //   }
  //
  //   return user;
  // }

  Widget _buildBody() {
    double h = MediaQuery.of(context).size.height;
    // final args = ModalRoute.of(context)!.settings.arguments as HomePage;

    return Stack(
      alignment: Alignment.bottomCenter,
      // mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Image.network("https://images.unsplash.com/photo-1617396900799-f4ec2b43c7ae?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxjb2xsZWN0aW9uLXBhZ2V8MTl8Q1RSVHU5NGZ1OW98fGVufDB8fHx8&w=1000&q=80",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,),
        Positioned(
          top: h/3 , height:h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Welcome to NFT Image App",style: TextStyle(
                  color: Colors.white,
                  fontSize: 20
              ),
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(15),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    primary: Colors.white
                ),
                child:  _isProcessing?Center(
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(
                      Colors.blueGrey,
                    ),
                  ),
                ):Row(
                  children: [
                    Image.asset('assets/google.png',scale: 1.5,),
                    SizedBox(
                      width: 5,
                    ),
                    Text('Sign in with Google',style: TextStyle(color: Colors.blueGrey),),
                  ],
                ),
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
                      Navigator.of(context).pushNamedAndRemoveUntil('/homepage', (route) => true);
                    }
                  }).catchError((error) {
                    print('Registration Error: $error');
                  });
                  setState(() {
                    _isProcessing = false;
                  });

                },

              ),
            ],
          ),
        ),
      ],
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
    });
    _googleSignIn.signInSilently();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: _buildBody(),
        ));
  }
}

