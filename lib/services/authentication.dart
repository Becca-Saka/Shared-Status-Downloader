import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:fipple/auth/user_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';



class AuthService{
  final FirebaseAuth _fireBaseAuth = FirebaseAuth.instance;
  // final GoogleSignIn _googleSignIn = GoogleSignIn();
  // final fbLog = FacebookLogin();
  // void saveUser(UserDetails userDetails) {
  //   Firestore.instance
  //       .collection("Users")
  //       .document(userDetails.uid)
  //       .setData(userDetails.createMap());
  // }

  // Future<FirebaseUser> getCurrentUser() async {
  //   FirebaseUser user = await _fireBaseAuth.();
  //   return user;
  // }

  // Future<String> getUser() async {
  //   FirebaseUser user = await _fireBaseAuth.currentUser();
  //   return user.uid;
  // }

  // Future<void> sendEmailVerification() async {
  //   FirebaseUser user = await _fireBaseAuth.currentUser();
  //   user.sendEmailVerification();
  // }

  // Future<bool> isEmailVerified() async {
  //   FirebaseUser user = await _fireBaseAuth.currentUser();
  //   return user.isEmailVerified;
  // }

  // Future<void> changePassword(String password) async {
  //   FirebaseUser user = await _fireBaseAuth.currentUser();
  //   user.updatePassword(password).then((_) {
  //     print('Password changed');
  //   }).catchError((error) {
  //     print('Password can\'t be changed' + error.toString());
  //   });
  //   return null;
  // }

  // Future<void> deleteUser() async {
  //   FirebaseUser user = await _fireBaseAuth.currentUser();
  //   user.delete().then((_) {
  //     print('Done');
  //   }).catchError((error) {
  //     print('User can\'t be changed' + error.toString());
  //   });
  //   return null;
  // }

  Future<void> sendPasswordResetEmail(String email) async {
    await _fireBaseAuth.sendPasswordResetEmail(email: email);
    return null;
  }

  bool isSignIn() {
    final firebaseUser =  _fireBaseAuth.currentUser;
    
    return firebaseUser!=null;
  }

  Future<void> signUp(String email, String password) async {
    try{
     final result = await _fireBaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);

      print(result);


      

    }catch(e){


    }
    
    // UserUpdateInfo update  = UserUpdateInfo();
    //  update.displayName = username;
    //  await user.updateProfile(update);
    //  await user.reload();
    //  UserDetails userDetails = UserDetails(name: username,
    //     uid: user.uid, email: user.email);
    // return userDetails;
  }

  Future<String> signInUser(String email, String password) async {
    FirebaseUser user;
    String errorMessage;
    //todo:handle try and catch(error messages generally)
    try{
      await _fireBaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      // user = await getCurrentUser();
    }catch(error){
      switch(error.code){
        case "ERROR_INVALID_EMAIL":
          errorMessage = "Invalid email";
          break;
      }
    }

    return user.uid;
  }

  Future<void> signOut() async => _fireBaseAuth.signOut();

  // Future<UserDetails> fbSignin(BuildContext context) async {
  //   final FacebookLoginResult result =
  //   await fbLog.logIn(['email', 'public profile']);
  //   final AuthCredential credential = FacebookAuthProvider.getCredential();

  //   final AuthResult authResult = await _fireBaseAuth.signInWithCredential(
  //       credential);
  //   final FirebaseUser user = authResult.user;

  //   UserDetails userDetails = UserDetails(name: user.displayName,
  //       uid: user.uid, email: user.email, photoUrl: user.photoUrl);
  //   return userDetails;
  // }

  // Future<void> signOutFacebook() async {
  //   await fbLog.logOut();
  // }

  // Future<UserDetails> signWithGoogle() async {
  //   final GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
  //   final GoogleSignInAuthentication googleSignInAuthentication =
  //   await googleSignInAccount.authentication;
  //   final AuthCredential credential = GoogleAuthProvider.getCredential(
  //       idToken: googleSignInAuthentication.idToken,
  //       accessToken: googleSignInAuthentication.accessToken);
  //   final AuthResult authResult = await _fireBaseAuth.signInWithCredential(
  //       credential);
  //   final FirebaseUser user = authResult.user;


  //   assert(!user.isAnonymous);
  //   assert(await user.getIdToken() != null);

  //   final FirebaseUser currentUser = await _fireBaseAuth.currentUser();
  //   assert(user.uid == currentUser.uid);
  //   UserDetails userDetails = UserDetails(name: user.displayName,
  //       uid: user.uid, email: user.email, photoUrl: user.photoUrl);
  //   return userDetails;
  // }

  // Future<void> signOutGoogle() async {
  //   await _googleSignIn.signOut();
  // }



}
