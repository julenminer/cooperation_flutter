import 'package:cached_network_image/cached_network_image.dart';
import 'package:cooperation/BL/authentication_bl.dart';
import 'package:cooperation/BL/user_bl.dart';
import 'package:cooperation/GUI/log_in_gui.dart';
import 'package:flutter/material.dart';

class ProfileGUI extends StatefulWidget {
  @override
  _ProfileGUIState createState() => _ProfileGUIState();
}

class _ProfileGUIState extends State<ProfileGUI> {
  @override
  void initState() {
    super.initState();
    UserBL.getUpdatedCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Scrollbar(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 150,
                      width: 150,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(200),
                        child: CachedNetworkImage(
                          imageUrl: UserBL.getPhotoUrl(),
                          fit: BoxFit.fill,
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      UserBL.getName(),
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      maxLines: 2,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      UserBL.getEmail(),
                      style: TextStyle(fontSize: 18),
                      maxLines: 2,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: OutlineButton(
                  highlightColor: Colors.blue[100],
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)),
                  onPressed: () {},
                  child: Text(
                    "Editar perfil",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Expanded(
                child: OutlineButton(
                  highlightColor: Colors.blue[100],
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)),
                  onPressed: () {
                    Auth auth = new Auth();
                    auth.signOut();
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LogInGUI()),
                    );
                  },
                  child: Text(
                    "Cerrar sesión",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
