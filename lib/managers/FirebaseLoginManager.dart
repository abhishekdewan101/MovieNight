import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseLoginManager {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = new GoogleSignIn(
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ]
  );

  Future<GoogleSignInAccount> signInGoogleSilenty() {
    return _googleSignIn.signInSilently();
  }

  Future<GoogleSignInAuthentication> getGoogleAuthentication(GoogleSignInAccount account) {
    return account.authentication;
  }

  Future<FirebaseUser> signInToFirebaseWithGoogle(String idToken, String accessToken) {
    return _auth.signInWithGoogle(idToken: idToken, accessToken: accessToken);
  }

  void signOut() {
    _auth.signOut();
    _googleSignIn.signOut();
  }

  Future<GoogleSignInAccount> signInToGoogle() {
    return _googleSignIn.signIn();
  }

  Stream<GoogleSignInAccount> getGoogleSignInListener() {
    return _googleSignIn.onCurrentUserChanged;
  }

  Future<FirebaseUser> getFirebaseUser() {
    return _auth.currentUser();
  }

  GoogleSignInAccount getGoogleUser() {
    return _googleSignIn.currentUser;
  }

  Future<FirebaseUser> createUserWithEmailAndPassword(String email,String password) {
    return _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<FirebaseUser> loginUserWithEmailAndPassword(String email,String password) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  void updateUserDetails(UserUpdateInfo userUpdateInfo) {
    _auth.updateProfile(userUpdateInfo);
  }

}