import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooperation/DB/carto_db.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;

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
        await document.reference.updateData({
          "lastMessage": message,
          "lastMessageDate": timestamp,
          "lastRead": document.data['fromUid'] == fromUid,
        });
      }
    }
  }

  static Future<String> getConversationId(String fromUid, String toUid) async {
    var documents = await Firestore.instance
        .collection('conversations')
        .where('fromUid', isEqualTo: fromUid)
        .where('toUid', isEqualTo: toUid)
        .getDocuments();
    if (documents.documents.length == 0) {
      return null;
    } else {
      return documents.documents.elementAt(0).data['conversationId'];
    }
  }

  static Future<void> saveUserInfo(
      String uid, String name, String photoURL) async {
    final doc = Firestore.instance.collection('users').document(uid);
    var snapshot = await doc.get();
    if (!snapshot.exists) {
      await doc.setData({
        'name': name,
      });

      var response = await http.get(photoURL);
      if (response.statusCode == 200) {
        final StorageReference storageReference =
            FirebaseStorage().ref().child("userImages/" + uid + ".png");

        final StorageUploadTask uploadTask = storageReference.putData(
          response.bodyBytes,
          StorageMetadata(
            contentType: 'image/png',
          ),
        );
        await uploadTask.onComplete;
      } else {
        print("ERROR: " + response.body);
      }
    }
  }

  static Future<String> getUserName(String uid) async {
    final doc =
        await Firestore.instance.collection('users').document(uid).get();
    return doc.data['name'];
  }

  /// Given the user id, an image and a new name, it updates the information
  /// of the user.
  ///
  /// Requires the [uid]. [image] and [name] are optional, updates
  /// the non null values of this parameters in the database.
  static Future<void> updateUser(String uid, File image, String name) async {
    Map<String, dynamic> newValues = {};
    if (name != null) {
      newValues.addAll({'name': name});
      CartoDB.updateCreatorName(uid, name);

      var conversations = await Firestore.instance.collection("conversations").where("toUid", isEqualTo: uid).getDocuments();

      for(var convDocument in conversations.documents){
        convDocument.reference.updateData({"toName": name});
      }
    }
    String imageUrl;
    if (image != null) {
      String path = "userImages/" + uid + ".png";
      String path_small = "userImages/" + uid + "_100x100.png";
      final StorageReference firebaseStorageRef =
          FirebaseStorage.instance.ref().child(path);
      try {
        await firebaseStorageRef.delete();
      } catch (e) {
        print(e.toString());
      }

      final StorageReference firebaseStorageRef_small =
          FirebaseStorage.instance.ref().child(path_small);
      try {
        await firebaseStorageRef_small.delete();
      } catch (e) {
        print(e.toString());
      }

      final StorageUploadTask task = firebaseStorageRef.putFile(
        image,
        StorageMetadata(
          contentType: 'image/png',
        ),
      );
      StorageTaskSnapshot storageTaskSnapshot = await task.onComplete;
      imageUrl = await storageTaskSnapshot.ref.getDownloadURL();
      newValues.addAll({'imageUrl': imageUrl});
    }
  }
}
