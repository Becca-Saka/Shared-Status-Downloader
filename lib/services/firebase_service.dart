import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:status_downloader/models/status_details.dart';
import 'package:status_downloader/router/locator.dart';
import 'package:status_downloader/models/user_details.dart';

import 'authentication.dart';
import 'dynamic_link_service.dart';
class FireBaseService{
  // final AuthService _authService = AuthService() ;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  StorageReference ref =FirebaseStorage.instance.ref().child('Statuses');
 
  CollectionReference collectionRef = FirebaseFirestore.instance.collection('Statuses');

   CollectionReference usersRef = FirebaseFirestore.instance.collection('Users');
   DynamicLinkService _dynamicLinkService =locator<DynamicLinkService>();

   Future<void> saveUserToDatabase(email, name) async{
     final userId = _firebaseAuth.currentUser.uid;  
    UserDetails details = UserDetails(email: email, name: name,uid: userId);
    await usersRef.doc(userId).set(details.createMap());
    print(' user database set done');


  }


 Future<String> uploadFile(file, bool isImage, {Uint8List thumb}) async{
    String shareLink;
   print(' doing upload');
    DocumentReference documentRef = collectionRef.doc();
    String id = documentRef.id;
    StorageReference imageRef = ref.child(isImage ==true?'Images':'Videos').child(isImage ==true?'$id.jpg':'$id.mp4');
    StorageTaskSnapshot upload = await imageRef.putFile(file).onComplete;
  
    if(upload.error == null){
      print('uploaded');
      final String url = await upload.ref.getDownloadURL();
      print(url);
      shareLink= await uploadToDatabase(documentRef,thumb, url,isImage);
      //  await  getLinkFromDataBase(id);
      // await uploadToDatabase(documentRef, url);
      
    
    print('saved');

    return shareLink;

    }
  }
  Future<String> uploadToDatabase(DocumentReference documentRef, Uint8List thumb, String url, bool isImage) async{
    String shareLink;
    final userId = _firebaseAuth.currentUser.uid;   
    DocumentReference user = usersRef.doc(userId);
    String id = documentRef.id;
    
    print(documentRef.id);
    StatusDetails statusDetails =  isImage ==true?StatusDetails(
      uid: id,
      url: url, userId: userId, fileType:'Image',
       date: DateTime.now()
    ): StatusDetails(
      uid: id,thumb: base64Encode(thumb),
      url: url, userId: userId, fileType:'Video',
       date: DateTime.now()
    );
    await documentRef.set(isImage ==true?statusDetails.createImageMap():
    statusDetails.createVideoMap());
    print(' status database set done');

    UserDetails details = UserDetails(sharedByYou:[id]);
    await user.update(details.sharedByYouMap());
    print(' user database set done');
     shareLink = await getLinkFromDataBase(userId,url,isImage ==true?'Image':'Video',id);

     StatusDetails update = StatusDetails(shareLink: shareLink);
    await documentRef.set(update.updateMap(), SetOptions(merge:true));


    return shareLink;


  }
  Future<void> updateSharedWithYou(id) async {
    print('updating');
    print(id);
    final userId = _firebaseAuth.currentUser.uid;   
    DocumentReference user = usersRef.doc(userId);
    UserDetails details = UserDetails(sharedWithYou:[id]);
    await user.update(details.sharedWithYouMap());
    print(' user database set done');

  }
  
  Future<String> getLinkFromDataBase(String userId,String uploadUrl,
   String uploadType,String docId) async {
  
    final String url = await  _dynamicLinkService.createDynamicLink('status',docId,userId, uploadUrl,uploadType: uploadType);

    return url;
    
  }

   Future<UserDetails> getAllFromDataBase() async {
    print('getting users');
    final userId =_firebaseAuth.currentUser.uid;
    
    print(userId);
    final doc = await usersRef.doc(userId).get();
     print('got doc');
    

     return UserDetails.fromFireStore(doc.data());
    
  }


 
   Future<List<StatusDetails>> getSharedByYou (UserDetails documentLinks)async{
     List<StatusDetails> statusDetails=[];
     final allData = await collectionRef.get();
     final result = allData.docs.map((document) => 
     StatusDetails.fromFireStore(document.data()));
       print('getting items');
      for(final item in result){
        
        for(final status in documentLinks.sharedByYou){
          
          if(item.uid ==status){

            statusDetails.add(item);
            print('hii');
            print(item.url);
          }
        }
      }
   print('done with items getting');
   
    return statusDetails;
    
  }
 Future<List<StatusDetails>> getSharedWithYou (UserDetails documentLinks)async{
     List<StatusDetails> statusDetails=[];
     final allData = await collectionRef.get();
     final result = allData.docs.map((document) => 
     StatusDetails.fromFireStore(document.data()));
       print('getting items');
      for(final item in result){
        
        for(final status in documentLinks.sharedWithYou){
          
          if(item.uid ==status){

            statusDetails.add(item);
            print('hii');
            print(item.url);
          }
        }
      }
   print('done with items getting');
   
    return statusDetails;
    
  }

 Future<DocumentSnapshot> getEachSharedByYou(docId) async{
    return await collectionRef.doc(docId).get();
  }

 

}