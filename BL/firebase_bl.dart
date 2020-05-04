import 'package:cooperation/BL/user_bl.dart';
import 'package:cooperation/DB/firebase_db.dart';

import 'package:http/http.dart' as http;

class FirebaseBL {
  static String getUserPhotoUrl(String uid) {
    return "gs://tfmapp-a3d38.appspot.com/userImages/" + uid + "_100x100.png";
  }

  static String getUserOriginalPhotoUrl(String uid) {
    return "gs://tfmapp-a3d38.appspot.com/userImages/" + uid + ".png";
  }
  static Future<String> createConversation(String toUid, String message) async {
    return await FirebaseDB.createConversation(toUid, UserBL.getUid(), UserBL.getName(), message);
  }

  static Future<void> sendMessage(String message, String conversationId, String toUid) async {
    await FirebaseDB.sendMessage(UserBL.getUid(), message, DateTime.now(), conversationId, true);
    sendNotification(toUid);
  }

  static Future<String> getConversationId(String fromUid, String toUid) async {
    return await FirebaseDB.getConversationId(fromUid, toUid);
  }

  static Future<void> sendNotification(String toUid) {
    var base = 'https://us-central1-tfmapp-a3d38.cloudfunctions.net/sendNotification';
    String name = UserBL.getName();
    String dataURL = '$base?toUid=$toUid&name=$name';
    print(dataURL);
    http.get(dataURL).then((response) {
      print(response.body);
    });
  }
}