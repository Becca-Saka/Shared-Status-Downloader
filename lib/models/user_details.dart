import 'package:cloud_firestore/cloud_firestore.dart';

class UserDetails{
  String email,uid,name;
  List<String> sharedWithYou,sharedByYou;


  UserDetails({this.email, this.uid, this.name, this.sharedByYou,this.sharedWithYou});

  Map<String, dynamic> createMap(){
    return{
      'email' : email,
      'uid' : uid,
      'name' : name,
    };
  }
   Map<String, dynamic> sharedByYouMap(){
    return{
      'sharedByYou': FieldValue.arrayUnion(sharedByYou),
    };
  }

    Map<String, dynamic> sharedWithYouMap(){
    return{

      'sharedWithYou': FieldValue.arrayUnion(sharedWithYou) 
    };
  }

  UserDetails.fromFireStore(Map fireStore)
      : uid = fireStore['uid'],
        name = fireStore['name'],
        email = fireStore['email'],
        sharedByYou= List.castFrom(fireStore['sharedByYou']??[]),
        sharedWithYou= List.castFrom(fireStore['sharedWithYou']??[])
        ;
}