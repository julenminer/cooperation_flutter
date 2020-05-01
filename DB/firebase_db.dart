import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooperation/BL/user_bl.dart';

class FirebaseDB {
  static Future<String> createConversation(
      String toUid, String fromUid, String fromName, String message) async {
    var toUserDocument =
        await Firestore.instance.collection("users").document(toUid).get();
    var newConversationDocumentReference =
        await Firestore.instance.collection("conversations").document();
    var conversationId = newConversationDocumentReference.documentID;
    var timestamp = DateTime.now();
    await newConversationDocumentReference.setData({
      "fromUid": fromUid,
      "toUid": toUid,
      "toName": toUserDocument.data['name'],
      "lastMessage": message,
      "lastMessageDate": timestamp,
      "conversationId": conversationId,
      "lastRead": true,
    });

    await Firestore.instance.collection("conversations").document().setData({
      "fromUid": toUid,
      "toUid": fromUid,
      "toName": fromName,
      "lastMessage": message,
      "lastMessageDate": timestamp,
      "conversationId": conversationId,
      "lastRead": false,
    });

    await sendMessage(fromUid, message, timestamp, conversationId, false);
    return conversationId;
  }

  static Future<void> sendMessage(
      String fromUid,
      String message,
      DateTime timestamp,
      String conversationId,
      bool updateConversations) async {
    await Firestore.instance.collection("messages").document().setData({
      "uid": fromUid,
      "message": message,
      "timestamp": timestamp,
      "conversationId": conversationId,
    });
    if (updateConversations) {
      var query = await Firestore.instance
          .collection("conversations")
          .where("conversationId", isEqualTo: conversationId)
          .getDocuments();
      for (var document in query.documents) {
        await Firestore.instance
            .collection("conversations")
            .document(document.documentID)
            .updateData({
          "lastMessage": message,
          "lastMessageDate": timestamp,
          "lastRead": document.data['fromUid'] == fromUid,
        });
      }
    }
  }
}
