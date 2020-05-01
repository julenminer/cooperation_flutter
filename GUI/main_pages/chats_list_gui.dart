import 'package:cached_network_image/cached_network_image.dart';
import 'package:cooperation/BL/firebase_bl.dart';
import 'package:cooperation/BL/user_bl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatsListGUI extends StatefulWidget {
  @override
  _ChatsListGUIState createState() => _ChatsListGUIState();
}

class _ChatsListGUIState extends State<ChatsListGUI> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
        stream: Firestore.instance
            .collection('conversations')
            .where('fromUid', isEqualTo: UserBL.getUid())
            .orderBy("lastMessageDate")
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );U
          } else {
            if (snapshot.data.documents.length == 0) {
              return SizedBox.expand(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Aún no tienes ningún mensaje.",
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            } else {
              return ListView.separated(
                separatorBuilder: (context, index) => Divider(),
                padding: EdgeInsets.all(16),
                itemBuilder: (context, index) =>
                    ChatListItem(document: snapshot.data.documents[index]),
                itemCount: snapshot.data.documents.length,
              );
            }
          }
        },
      ),
    );
  }
}

class ChatListItem extends StatelessWidget {
  ChatListItem({@required this.document});
  DocumentSnapshot document;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(60),
            child: SizedBox(
              width: 60,
              height: 60,
              child: CachedNetworkImage(
                imageUrl: FirebaseBL.getUserPhotoUrl(document.data['toUid']),
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
          ),
          SizedBox(
            width: 16,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  document.data['toName'],
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  document.data['lastMessage'],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
          ),
          Icon(Icons.keyboard_arrow_right),
        ],
      ),
    );
  }
}
