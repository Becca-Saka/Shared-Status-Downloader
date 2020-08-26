import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
class FireBaseService{
  StorageReference ref =FirebaseStorage.instance.ref().child('Status Downloader');
  CollectionReference collectionRef = FirebaseFirestore.instance.collection('Status Downloader');


 uploadFile(file, bool isImage) async{
   print(' doing upload');
    DocumentReference documentRef = collectionRef.doc();
    String id = documentRef.id;
    StorageReference imageRef = ref.child(isImage ==true?'Images':'Videos').child(id);
    StorageTaskSnapshot upload = await imageRef.putFile(file).onComplete;
  
    if(upload.error == null){
      print('uploaded');
      final String url = await upload.ref.getDownloadURL();
       await uploadToDatabase(documentRef, url);
       await  getLinkFromDataBase(id);
      
    
    print('saved');

    }
  }
  Future<void> uploadToDatabase(DocumentReference documentRef, String url) async{
  
    print(documentRef.id);
    await documentRef.set({
      'url': url,
      'date': DateTime.now(),
    });

  }
  
  Future<String> getLinkFromDataBase(id) async {
    String id;
    await collectionRef.doc(id).get().then((document) {
      final doc = document.data();
      print(doc);
      // id = doc.;
    });
    print(id);

    return id;
    
  }

}