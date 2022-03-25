import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:firebase/firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart' as fb;

class HomeScreen extends StatefulWidget {
  static const route = '/homescreen';
  const HomeScreen({Key? key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("nft").snapshots(),
      builder:(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        if(!snapshot.hasData){
            return Text("NO DATA");
        }
        else{
          return new GridView.builder(
            itemCount: snapshot.data!.docs.length,
              scrollDirection:  Axis.vertical,
              shrinkWrap:  true,
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount:  4
              ),
              itemBuilder: (BuildContext context, int index){
                DocumentSnapshot doc = snapshot.data!.docs[index];
                return FutureBuilder(
                  future: downloadURLS(doc["images"]),
                  builder:  (context, image){
                    print("YYY");
                    print(image.data);
                    return Center(
                      child: Card(
                        child: InkWell(
                          splashColor: Colors.blue.withAlpha(30),
                          // onTap: (){
                          // },
                          child: Container(
                              child: Image.network(image.data.toString())
                              // child: Image.network("https://picsum.photos/250?image=9")
                          ),
                        ),
                      ),
                  );},
                );
              });
          // return new ListView.builder(
          //     itemCount: snapshot.data!.docs.length,
          //     itemBuilder: (context, index){
          //       DocumentSnapshot doc = snapshot.data!.docs[index];
          //
          //       // return Text(doc['title']);
          // });
        }
      }
    );
    // return GridView.count(
    //   crossAxisCount: 4,
    //   children: List.generate(100, (index) {
    //     return Center(
    //       child: Text(
    //         'Item $index',
    //         style: Theme.of(context).textTheme.headline5,
    //       ),
    //     );
    //   }),
    // );
  }


  Future<Uri> downloadURLS(String image)
  {
    print("Download URL");
    return fb.storage().refFromURL("gs://nft-image-app.appspot.com/")
        .child(image).getDownloadURL();

  }
}
