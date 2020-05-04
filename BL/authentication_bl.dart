import 'dart:async';
import 'package:cooperation/BL/user_bl.dart';
import 'package:cooperation/DB/firebase_db.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Class to authenticate users and mantain the log in.
class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;


  /// Shows a page where users can log in using Google.
  Future<String> googleSignIn(String langCode, String countryCode) async {
    try {
      final gSignIn = new GoogleSignIn();
      GoogleSignInAccount googleSignInAccount = await gSignIn.signIn();
      GoogleSignInAuthentication auth =
          await googleSignInAccount.authentication;

      if (auth != null) {
        AuthCredential credential = GoogleAuthProvider.getCredential(
            idToken: auth.idToken, accessToken: auth.accessToken);
        return _signIn(credential, langCode, countryCode);
      } else {
        throw ("UnknownError");
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  /// Given a credential, it creates a FirebaseUser, save the user information
  /// in Firestore and return the user id.
  Future<String> _signIn(AuthCredential credential, String langCode, String countryCode) async {
    FirebaseUser user = (await _firebaseAuth.signInWithCredential(credential)).user;
    if (user != null) {
      String token = await FirebaseMessaging().getToken();
      FirebaseDB.saveUserInfo(
          user.uid, user.displayName, user.photoUrl, token);
    }
    return user.uid;
  }

  /// This function is only used when the app is starting.
  /// It checks if Firebase Auth has a logged user on the device.
  Future<bool> isLogged() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user != null;
  }

  /// Returns the user that has been logged before.
  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  /// Sing out function to remove the user from the device.
  Future<void> signOut() async {
    String token = await FirebaseMessaging().getToken();
    await FirebaseDB.removeToken(UserBL.getUid(), token);
    UserBL.signOut();
    return await _firebaseAuth.signOut();
  }
}
