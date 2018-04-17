import 'dart:async';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:log/log.dart';
import 'package:movieee_app/data/NetworkManager.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseDatabaseManager {

  FirebaseDatabase mFirebaseDatabase;
  DatabaseReference userDBReference;
  DatabaseReference pollDBReference;
  FirebaseStorage mFirebaseStorage;
  StorageReference mProfileImageStorageReference;

  final String EMAIL_KEY = "email";
  final String FIRST_NAME_KEY = "firstName";
  final String LAST_NAME_KEY = "lastName";
  final String DISPLAY_NAME_KEY = "displayName";
  final String PHOTO_URL_KEY = "photourl";


  FirebaseDatabaseManager() {
    mFirebaseDatabase = FirebaseDatabase.instance;
    userDBReference = mFirebaseDatabase.reference().child("/users");
    pollDBReference = mFirebaseDatabase.reference().child("/poll");

    mFirebaseStorage = FirebaseStorage.instance;
    mProfileImageStorageReference = mFirebaseStorage.ref();
  }

  void pushLoggedInUserDetails(FirebaseUser user) {
    userDBReference.child(user.uid).set(
      {
        EMAIL_KEY : user.email,
        DISPLAY_NAME_KEY : user.displayName,
        PHOTO_URL_KEY : user.photoUrl
      }
    );
  }

  DatabaseReference pushPollData(FirebaseUser user, List<Movie> movies, String mPollName ) {
    DatabaseReference reference = pollDBReference.push();
    reference.set({
      "pollName" : mPollName,
      "movies": getFormattedMovieData(movies)
    });
    return reference;
  }

  void handleError(error) {
    print(error);
  }

  Map<String,int> getFormattedMovieData(List<Movie> movies) {
    Map<String,int> ids = new Map<String,int>();
    for (var movie in movies) {
      ids[movie.mId.toString()] = 0;
    }
    return ids;
  }

  DatabaseReference getPollDataFromFirebase(String pollId) {
    return pollDBReference.child(pollId);
  }

  Future<UploadTaskSnapshot> uploadProfileImage(File userProfileImage, String uid) {
    return mProfileImageStorageReference.child(uid).put(userProfileImage).future;
  }

  void updateMoviePollCount(Movie movie, String pollid, int count) {
    print("Count for movie ${movie.mTitle} is count ${count}");
    pollDBReference.child(pollid).child("movies").update({
      movie.mId.toString(): count
    });
  }

}