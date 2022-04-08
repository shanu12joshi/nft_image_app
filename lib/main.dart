import 'package:flutter/material.dart';
import 'package:nft_app/Auth/signscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:nft_app/Home/homepage.dart';
import 'package:nft_app/HomeScreen.dart';
import 'package:nft_app/Splash/splashscreen.dart';

Future<void> main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyD5YWN7DjOM6uynDOkj7EPHKE2R9wF-fqY",
        authDomain: "nft-image-app.firebaseapp.com",
        projectId: "nft-image-app",
        storageBucket: "nft-image-app.appspot.com",
        messagingSenderId: "551369306671",
        appId: "1:551369306671:web:56aad0313252e881268cda",
        measurementId: "G-XB8BLETKR4",)
  );
  runApp( MyApp());

}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // initialRoute: HomeScreen.route,
      // routes: {
      //   SignScreen.route:(context)=>SignScreen(),
      //   SplashScreen.route:(context)=>SplashScreen(),
      //   HomePage.route:(context)=>HomePage(),
      //   HomeScreen.route:(context) => HomeScreen()
      // },
      home: HomePage(),
    );
  }
}

