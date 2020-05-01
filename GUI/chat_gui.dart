import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooperation/BL/firebase_bl.dart';
import 'package:cooperation/BL/user_bl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatGUI extends StatefulWidget {
  ChatGUI({@required this.toName, @required this.toUid, this.conversationId});
  String toName;
  String toUid;
  String conversationId;

  @override
  _ChatGUIState createState() => _ChatGUIState();
}

class _ChatGUIState extends State<ChatGUI> {
  TextEditingController _controller;
  String _conversationIdState;

  @override
  void initState() {
    super.initState();
    _conversationIdState = widget.conversationId;
    _controller = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          widget.toName,
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 3,
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: _conversationIdState == null
                      ? Center(
                          child: Text(
                          "¡Envía el primer mensaje!",
                          textAlign: TextAlign.end,
                        ))
                      : Container(
                          child: StreamBuilder(
                            stream: Firestore.instance
                                .collection('messages')
                                .where('conversationId',
                                    isEqualTo: _conversationIdState)
                                .orderBy('timestamp', descending: true)
                                .limit(20)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else {
                                return ListView.builder(
                                  reverse: true,
                                  itemBuilder: (context, index) => Bubble(
                                      document: snapshot.data.documents[index]),
                                  itemCount: snapshot.data.documents.length,
                                );
                              }
                            },
                          ),
                        ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CupertinoTextField(
                  controller: _controller,
                  textCapitalization: TextCapitalization.sentences,
                  autocorrect: true,
                  placeholder: "Mensaje",
                  prefix: SizedBox(
                    width: 8,
                  ),
                  expands: true,
                  minLines: null,
                  maxLines: null,
                  suffix: IconButton(
                      icon: Icon(CupertinoIcons.up_arrow),
                      onPressed: () => _sendMessage()),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(80),
                      border: Border.all(
                        color: Colors.black26,
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _sendMessage() async {
    if (_controller.text.isNotEmpty) {
      if (_conversationIdState == null) {
        var newConversationId = await FirebaseBL.createConversation(widget.toUid, _controller.text);
        if(mounted){
          setState(() {
            _conversationIdState = newConversationId;
          });
        }
      } else {
        await FirebaseBL.sendMessage(_controller.text, _conversationIdState);
      }
      _controller.clear();
    }
  }
}

class Bubble extends StatelessWidget {
  Bubble({@required this.document});

  DocumentSnapshot document;

  @override
  Widget build(BuildContext context) {
    String fromUid = document.data['uid'];
    double leftPadding = 8;
    double rightPadding = 8;
    Color bubbleColor;
    List<Widget> space = [];

    if (fromUid == UserBL.getUid()) {
      leftPadding += 16;
      bubbleColor = Colors.blue[300];
      space.add(          Expanded(child: Container(),),
      );
    } else {
      rightPadding += 16;
      bubbleColor = Colors.grey[300];
    }
    return Padding(
      padding: EdgeInsets.fromLTRB(leftPadding, 8, rightPadding, 8),
      child: Row(
        children: space+  <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(80),
            child: Container(
              color: bubbleColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(document.data['message']),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
