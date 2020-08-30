import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';

class StatusDetails{
  String uid,url,userId, fileType,shareLink, thumb;
  var date;



  StatusDetails({this.uid,this.thumb,this.url, this.userId, this.shareLink, this.date,this.fileType});

  Map<String, dynamic> createImageMap(){
    return{
      'uid': uid,
      'url' : url,
      'userId' : userId,
      'date' : date,
      'fileType' : fileType,
    };
  }
   Map<String, dynamic> createVideoMap(){
    return{
      'uid': uid,
      'url' : url,
      'userId' : userId,
      'date' : date,
      'fileType' : fileType,
      'thumb': thumb,
    };
  }
   
  
   Map<String, dynamic> updateMap(){
    return{
      'shareLink' : shareLink,
    };
  }

  StatusDetails.fromFireStore(Map fireStore)
      : url = fireStore['url'],
        uid = fireStore['uid'],
        userId = fireStore['userId'],
        date = fireStore['date'],
        fileType = fireStore['fileType'],
        thumb = fireStore['thumb'],
        shareLink = fireStore['shareLink']
        ;
}