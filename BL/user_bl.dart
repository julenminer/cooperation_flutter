import 'dart:io';

import 'package:cooperation/DB/firebase_db.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Class to maintain the session of the user and perform functions with it.
class UserBL {
  static FirebaseUser _user;
  static String _name;

  /// Initializes the value of the user with the uid.
  static Future<void> init(FirebaseUser user) async {
    _user = user;
    _name = await FirebaseDB.getUserName(user.uid);
  }

  /// Checks if the user is logged.
  static bool isLogged() {
    return _user != null;
  }

  /// Updates and returns the information of the current user.
  static Future<void> updateCurrentUser() async {
    _user = await FirebaseAuth.instance.currentUser();
    _name = await FirebaseDB.getUserName(_user.uid);
  }

  /// Returns the uid of the current user.
  static String getUid() {
    assert(_user != null);
    return _user.uid;
  }

  /// Returns the name url of the current user.
  static String getName() {
    assert(_user != null);
    return _name;
  }

  static String getPhotoUrl() {
    assert(_user != null);
    return getUserPhotoUrl(getUid());
  }

  static String getEmail() {
    assert(_user != null);
    return _user.email;
  }

  /// Updates the information of the user.
  static Future<void> updateUser(File image, String name) async {
    await FirebaseDB.updateUser(UserBL.getUid(), image, name);
    await updateCurrentUser();
  }

  static void signOut() {
    _user = null;
    _name = null;
  }

  static String getUserPhotoUrl(String uid) {
    return "gs://tfmapp-a3d38.appspot.com/userImages/" + uid + "_100x100.png";
  }

  static String getUserOriginalPhotoUrl(String uid) {
    return "gs://tfmapp-a3d38.appspot.com/userImages/" + uid + ".png";
  }

  static Future<String> createConversation(String toUid, String message) async {
    return await FirebaseDB.createConversation(toUid, UserBL.getUid(), UserBL.getName(), message);
  }
}
