import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nft_app/Auth/signscreen.dart';
import 'package:nft_app/Home/homepage.dart';
import 'package:nft_app/HomeScreen.dart';

import '../Utils/authentication.dart';



class SplashScreen extends StatefulWidget {
  static const route = '/splashscreen';

  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // User?  result = FirebaseAuth.instance.currentUser;

  User? _user;
  @override
  void initState() {
    super.initState();
    getUserInfo();
    navigateUser();
  }

  // Future initializeUser() async {
  //   await Firebase.initializeApp();
  //   final User? firebaseUser = await FirebaseAuth.instance.currentUser;
  //   await firebaseUser?.reload();
  //   _user = await _auth.currentUser;
  // }

  Future getUserInfo() async {
    await getUser();
    setState(() {

    });
    print(uid);
  }


  navigateUser() async {
    // checking whether user already loggedIn or not
    if (_auth.currentUser != null) {
      print("_____adasda");
      // &&  FirebaseAuth.instance.currentUser.reload() != null
      Timer(
        Duration(seconds: 3),
            () => Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) =>
                HomeScreen()),
                    // HomePage()),
                (Route<dynamic> route) => false),
      );
    } else {
      print("_____PPPPPPPPPPPP");

      Timer(Duration(seconds: 4),
              () => Navigator.pushNamedAndRemoveUntil(context,'/signin', (route) => false));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: Text("NFT Image App"),
          ),
          Center(
            child: CircularProgressIndicator(),
          )
        ],
      ),
    );
  }
}