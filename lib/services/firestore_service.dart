// import 'dart:io';
// import 'dart:async';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:fipple/auth/authentication.dart';
// import 'package:fipple/book/models/book_details.dart';
// import 'package:fipple/helpers/comments_details.dart';
// import 'package:fipple/helpers/comments_reply_details.dart';
// import 'package:fipple/helpers/likes_class.dart';
// import 'package:fipple/book/models/chapter_details.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';

// class FireStoreService{


//   //todo:try and catch for all fields
//   //todo:use increment for getting no of published and draft

//   final db = Firestore.instance.collection("Book Details");
//   final auth = AuthService();
//   DocumentSnapshot lastDocument;

//   CollectionReference ref;
//   final ndb = Firestore.instance.collection("Book Details").document();

//   //todo: use fieldValue
//   var now = new DateTime.now().toUtc().millisecondsSinceEpoch;

//   Future<String> createNew(String title, String desc) async {
// //    final ndb = db.document();
//     String key = ndb.documentID;
//     FirebaseUser user = await auth.getCurrentUser();
//     BookDetails bd = new
//     BookDetails(bookKey: key, title: title,description: desc,
//         noOfDrafts: 0,noOfPublished: 0, totalLikes: 0,totalReaders: 0,totalSubscribers: 0,
//         writerId: user.uid,writer: user.displayName, date: FieldValue.serverTimestamp());

//     await ndb.setData(bd.createMap());
//     return key;
//   }
//   Future<String> createNewWithCover(String title, String cover, String desc) async {
//     final ndb = db.document();
//     String key = ndb.documentID;
//     FirebaseUser user = await auth.getCurrentUser();
//     BookDetails bd = new BookDetails(bookKey: key, title: title,description: desc,
//         noOfDrafts: 0,noOfPublished: 0, totalLikes: 0,totalReaders: 0,totalSubscribers: 0,
//         cover: cover,writerId: user.uid,
//         writer: user.displayName, date: FieldValue.serverTimestamp());

//     await ndb.setData(bd.createWithCoverMap());
//     return key;
//   }

//   Future<String> saveCover(File cover, String title) async {
//     StorageReference storageReference;

//     storageReference =
//         FirebaseStorage.instance.ref().child('Book Details').child(ndb.documentID).child(
//             '$now');
//     final StorageUploadTask uploadTask = storageReference.putFile(cover);
//     final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
//     final String url = (await downloadUrl.ref.getDownloadURL());
//     return url;
//   }

//   Stream<List<BookDetails>> getPublishedBooks(){

//     return db.where('publishStatus', isEqualTo: 'Published')
//         .snapshots().map((books) => books.documents.map((list) =>
//         BookDetails.fromSnap(list.data)).toList());
//   }

//   ///Getting data for feed

//   Stream<List<BookDetails>> getPopularBooks(){

//     return db.where('publishStatus', isEqualTo: 'Published')
//         .snapshots().map((books) => books.documents.map((list) =>
//         BookDetails.fromSnap(list.data)).toList());
//   }



//   Stream<List<BookDetails>> getBooks(){
// //    var stream;
// //    try{
// //      stream = db.snapshots().map((books) => books.documents.map((list) =>
// //          BookDetails.fromSnap(list.data)).toList());
// ////          BookDetails.fromFireStore(list.data)).toList());
// //    }catch(error){
// //      print(error);
// //    }
//     return db.snapshots().map((books) => books.documents.map((list) =>
//         BookDetails.fromSnap(list.data)).toList());
//   }

//   Future<BookDetails> bookDetails(String bookKey) async {
//     var doc = await db.document(bookKey).get();
// //    return BookDetails.fromFireStore(doc.data);
//     return BookDetails.fromSnap(doc.data);
//   }
//   //todo:crateMappingField for update
//   Future<void> updateBook(BookDetails bookDetails){
//     return db.document(bookDetails.bookKey)
//         .updateData(bookDetails.createWithCoverMap(),);
//   }
//   Future<void> updateCover(BookDetails bookDetails, String bookKey){
//     return db.document(bookKey)
//         .setData(bookDetails.updateCoverMap(), merge: true);
//   }
//   Future<void> updateBookPublishStatus(BookDetails bookDetails, bookKey){
//     return db.document(bookKey)
//         .setData(bookDetails.updatePublishStatusMap(), merge: true);
//   }
//   Future<void> updateSorted(BookDetails bookDetails, bookKey){
//     return db.document(bookKey)
//         .setData(bookDetails.updateSorted(), merge: true);
//   }
//   Future<void> addToCategory(BookDetails bookDetails, bookKey, String genre) async{
//     Map<String, dynamic> createMap() {
//       return {
//         bookKey : true,
//       };
//     }

//     return await Firestore.instance.collection("Book Details").document(genre)
//         .setData(createMap(), merge: true);
//   }

//   Future<void> deleteBook( bookKey) async{
//     return await db.document(bookKey).delete();
//   }


//   Future<void> updateBookBasics(BookDetails bookDetails, bookKey){
//     return db.document(bookKey)
//         .setData(bookDetails.updateBasicsMap(), merge: true);
//   }
//   Future<void> updateBookBasicsTag(BookDetails bookDetails, bookKey){
//     return db.document(bookKey)
//         .setData(bookDetails.updateBasicsTagMap(), merge: true);
//   }

//   Future<void> createNewChapter(String title, String content,
//       String bookKey, String status, String note) async {
//     final path = db.document(bookKey);
//     final cdb =path.collection('Chapters').document();
//     String key = cdb.documentID;
//     ChapterDetails chapterDetails = new ChapterDetails(chapterKey: key,
//     chapterContent: content,chapterTitle: title, totalComments: 0,totalLikes: 0,
//     authorNote: note,publishStatus: status,
//         date: now);
//     await cdb.setData(chapterDetails.toMap());
//   }

//   Future<void> updateBookChapter(ChapterDetails chapterDetails, String bookKey){
//     return db.document(bookKey).collection('Chapters')
//         .document(chapterDetails.chapterKey).updateData(chapterDetails.toMap());
//   }
//   Future<void> getNoOfPublished(ChapterDetails chapterDetails, String bookKey){
//     return db.document(bookKey).collection('Chapters')
//         .document(chapterDetails.chapterKey).updateData(chapterDetails.toMap());
//   }
//   Future<void> deleteChapter(String bookKey, String chapterKey) async {

//     return await db.document(bookKey).collection('Chapters').document(chapterKey).delete();
//   }


//   Stream<List<ChapterDetails>> getChapters(String bookKey){
//     return db.document(bookKey).collection('Chapters').snapshots().map((chapters) =>
//     chapters.documents.map((list) => ChapterDetails.fromFirestore(list.data)).toList());
//   }

//   Stream<List<ChapterDetails>> getChapterDetails(String bookKey){
//    return db.document(bookKey).collection('Chapters').snapshots()
//         .map((snapshot) => snapshot.documents.map((document) =>
//         ChapterDetails.fromFirestore(document.data)).toList());
//   }

//   Stream<QuerySnapshot> getChapterStream(String bookKey){

//     ref = db.document(bookKey).collection('Chapters');
//     return ref.snapshots();
//   }
//   Future<QuerySnapshot> getChapterList(String bookKey) async{

//     ref = db.document(bookKey).collection('Chapters');
//     return await ref.where('publishStatus', isEqualTo: 'Published').getDocuments();
//   }

//   Stream<List<ChapterDetails>> getPublishedChapters(String bookKey){
//     return db.document(bookKey).collection('Chapters')
//         .where('publishStatus', isEqualTo: 'Published')
//         .snapshots().map((chapters) =>
//         chapters.documents.map((list) => ChapterDetails.fromFirestore(list.data)).toList());
//   }
//   Future<List<ChapterDetails>> getPublishChapters(String bookKey) async{
//     final chapters = await db.document(bookKey).collection('Chapters')
// //        .where('publishStatus', isEqualTo: 'Published')
//         .orderBy('date', descending: false)
//         .getDocuments();
//     return chapters.documents.map((e) => ChapterDetails.fromFirestore(e.data)).toList();

//   }
//   Future<BookDetails> sortChapters(String bookKey)async{
//     final draftList = await db.document(bookKey).collection('Chapters')
//         .where('publishStatus', isEqualTo: 'Draft').getDocuments();
//     final publishedList = await db.document(bookKey).collection('Chapters')
//         .where('publishStatus', isEqualTo: 'Published').getDocuments();
//     BookDetails book = BookDetails(noOfPublished: publishedList.documents.length,
//     noOfDrafts: draftList.documents.length);
//     return book;
//   }
//   ///getting and adding Likes, Comment,library

//   Future<void> doLike(String bookKey,String chapterKey)async{
//     FirebaseUser user = await auth.getCurrentUser();
//     String userId = user.uid;
//     final bookPath =db.document(bookKey);
//     final path =bookPath.collection('Chapters').document(chapterKey);
//     final mainPath = path.collection('Likes').document(userId);



//     await mainPath.get()
//         .then((doc) => {
//       if(doc.exists){
//         mainPath.delete()
//             .whenComplete(() => path.updateData({'totalLikes': FieldValue.increment(-1)}))
//             .whenComplete(() => bookPath.updateData({'totalLikes': FieldValue.increment(-1)})),

//       }else{
//         mainPath.setData({'likedOn': now})
//             .whenComplete(() => path.updateData({'totalLikes': FieldValue.increment(1)}))
//             .whenComplete(() => bookPath.updateData({'totalLikes': FieldValue.increment(1)})),

//       }
//     });
//   }
//   Future<bool> initLike(String bookKey,String chapterKey)async{
//     FirebaseUser user = await auth.getCurrentUser();
//     String userId = user.uid;
//     final path =db.document(bookKey).collection('Chapters').document(chapterKey)
//         .collection('Likes');
//   bool liked;

//     await path.document(userId).get()
//         .then((doc) => {
//           if(doc.exists){
//             liked =true
//           }else{
//             liked =false,
//           }
//     });


//     return liked;
//   }
//   Future<String> newCommentId(String bookKey,String chapterKey,)async{
//     final path = db.document(bookKey).collection('Chapters').document(chapterKey)
//         .collection('Comments').document();
//     return path.documentID;
//   }
//   Future<void> postComments(String bookKey,String chapterKey,
//       CommentsDetails commentDetails)async{
//  final path =  db.document(bookKey).collection('Chapters').document(chapterKey);
//  await path.collection('Comments').document(commentDetails.id)
//      .setData(commentDetails.commentMap())
//      .whenComplete(() => path.updateData({'totalComments': FieldValue.increment(1)}));


//   }
//   Future<Likes> initCommentLike(String bookKey,String chapterKey,String id)async{
//     bool liked;
//     int likes;
//     FirebaseUser user = await auth.getCurrentUser();
//     String userId = user.uid;

//     final path =db.document(bookKey).collection('Chapters').document(chapterKey)
//         .collection('Comments').document(id).collection('CommentLikes');
//     await path.document(userId).get()
//         .then((doc) => {
//       if(doc.exists){
//         liked =true

//       }else{
//         liked =false,


//       }
//     });
//     await path.getDocuments().then((value) => {
//       likes = value.documents.length
//     });

//     return Likes(noOfLikes: likes, isLiked: liked);
//   }
//   Future<int> commentLike(String bookKey,String chapterKey,String id)async{
//     int likes;
//     FirebaseUser user = await auth.getCurrentUser();
//     String userId = user.uid;

//     final path =db.document(bookKey).collection('Chapters').document(chapterKey)
//         .collection('Comments').document(id).collection('CommentLikes');
//     await path.document(userId).get()
//         .then((doc) => {
//       if(doc.exists){
//         path.document(userId).delete(),

//       }else{
//         path.document(userId).setData({'likedOn': now}),
//       }
//     });



//     await path.getDocuments().then((value) => {
//       likes = value.documents.length
//     });

//     return likes;
//   }
//   Future<String> newCommentReplyId(String bookKey,String chapterKey,String commentKey)async{
//     final path = db.document(bookKey).collection('Chapters').document(chapterKey)
//         .collection('Comments').document();
//     return path.documentID;
//   }
//   Future<void> commentsReply(String bookKey,String chapterKey,
//       String username, String commentKey, commentReply)async{
//     final path =db.document(bookKey).collection('Chapters').document(chapterKey)
//         .collection('Comments').document(commentKey);
//     path..collection('CommentReplies').document(commentReply.id)
//         .setData(commentReply.commentMap())
//         .whenComplete(() => path.updateData({'repliesCount': FieldValue.increment(1)}));
//   }
//   Future<int> commentReplyLike(String bookKey,String chapterKey,
//       String commentKey,String id)async{
//     int likes;
//     FirebaseUser user = await auth.getCurrentUser();
//     String userId = user.uid;

//     final path =db.document(bookKey).collection('Chapters').document(chapterKey)
//         .collection('Comments').document(commentKey).collection('CommentReplies')
//         .document(id);
//     final child = path.collection('ReplyLikes');
//     await child.document(userId).get()
//         .then((doc) => {
//       if(doc.exists){
//         child.document(userId).delete().whenComplete(() => path.updateData({'likesCount': FieldValue.increment(-1)})),

//       }else{
//         child.document(userId).setData({'likedOn': now})
//             .whenComplete(() => path.updateData({'likesCount': FieldValue.increment(1)})),
//       }
//     });


// //    await path.getDocuments().then((value) => {
// //      likes = value.documents.length
// //    });

//     return likes;
//   }



//   Future<List<CommentsDetails>> fetchComments(String bookKey,String chapterKey)async{
//     final docs =await db.document(bookKey).collection('Chapters').document(chapterKey)
//         .collection('Comments').getDocuments();
//     List<CommentsDetails> commentsDetails = docs.documents.map((e) => CommentsDetails.fromSnap(e.data)).toList();
//     print(commentsDetails[0].comment);
//     return commentsDetails;
//   }

//   Future<List<CommentsReplyDetails>> fetchCommentsReplies(String bookKey, String commentKey,
//       String chapterKey)async{
//     final docs =await db.document(bookKey).collection('Chapters').document(chapterKey)
//         .collection('Comments').document(commentKey).collection('CommentReplies').getDocuments();
//     List<CommentsReplyDetails> commentsDetails = docs.documents.map((e) => CommentsReplyDetails.fromSnap(e.data)).toList();

//     return commentsDetails;
//   }
//   Future<bool> initCommentReplyLike(String bookKey,String chapterKey,String id, String commentKey,)async{
//     bool liked;
//     FirebaseUser user = await auth.getCurrentUser();
//     String userId = user.uid;

//     final path =db.document(bookKey).collection('Chapters').document(chapterKey)
//         .collection('Comments').document(commentKey)
//         .collection('CommentReplies').document(id).collection('CommentLikes');
//     await path.document(userId).get()
//         .then((doc) => {
//       if(doc.exists){
//         liked =true

//       }else{
//         liked =false,


//       }
//     });

//     return liked;
//   }



// }