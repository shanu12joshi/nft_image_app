import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nft_app/Utils/authentication.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';


class NftService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<void> uploadNft(
      {
        String? title,
        String? description,
        String? twitter,
        String? image,
        String? userid
        }
      )
  async {
    //used for generatng id for nft in project
    var id = Uuid();
    String nftId = id.v1();
    String downloadUrl = await _firebaseStorage.ref(image).getDownloadURL();
    if(downloadUrl!=null){
      _firestore.collection('nft').doc(nftId).set({
        'title': title,
        'id': nftId,
        'description': description,
        'twitter':twitter,
        'images': downloadUrl,
        "userid":userid
      });
    }
   else{
     Fluttertoast.showToast(msg: "Select Nft Artwork");
    }
  }

}
