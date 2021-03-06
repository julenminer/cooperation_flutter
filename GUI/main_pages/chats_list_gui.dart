import 'package:cache_image/cache_image.dart';
import 'package:cooperation/BL/user_bl.dart';
import 'package:cooperation/GUI/chat_gui.dart';
import 'package:cooperation/localization/AppLocalizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatsListGUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
        stream: Firestore.instance
            .collection('conversations')
            .where('fromUid', isEqualTo: UserBL.getUid())
            .orderBy("lastMessageDate", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.data.documents.length == 0) {
              return SizedBox.expand(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    AppLocalizations.of(context).noMessages,
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            } else {
              return ListView.separated(
                separatorBuilder: (context, index) => Divider(),
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
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatGUI(
                toName: document.data['toName'],
                toUid: document.data['toUid'],
                conversationId: document.data['conversationId'],
              ),
            ));
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          child: Row(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: SizedBox(
                  width: 60,
                  height: 60,
                  child: Image(
                    fit: BoxFit.fill,
                    image: CacheImage(UserBL.getUserPhotoUrl(document.data['toUid'])),
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
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
              Visibility(
                visible: !document.data['lastRead'],
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(80),
                  child: SizedBox(
                    height: 15,
                    width: 15,
                    child: Container(
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ),
              ),
              Icon(Icons.keyboard_arrow_right),
            ],
          ),
        ),
      ),
    );
  }
}
