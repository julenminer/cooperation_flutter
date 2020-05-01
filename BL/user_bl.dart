import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';

/// Class to maintain the session of the user and perform functions with it.
class UserBL {
  static FirebaseUser _user;

  /// Initializes the value of the user with the uid.
  static Future<void> init(FirebaseUser user) async {
    _user = user;
  }

  /// Checks if the user is logged.
  static bool isLogged() {
    return _user != null;
  }

  /// Given a [uid], returns the corresponding user.
  static FirebaseUser getUser(String uid)  {
    return _user;
  }

  /// Updates and returns the information of the current user.
  static Future<FirebaseUser> getUpdatedCurrentUser() async {
    return await FirebaseAuth.instance.currentUser();
  }

  /// Returns the uid of the current user.
  static String getUid() {
    assert(_user != null);
    return _user.uid;
  }

  /// Returns the name url of the current user.
  static String getName() {
    assert(_user != null);
    return _user.displayName;
  }

  static String getPhotoUrl() {
    assert(_user != null);
    return _user.photoUrl;
  }

  static String getEmail() {
    assert(_user != null);
    return _user.email;
  }
}
