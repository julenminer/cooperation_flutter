import 'dart:async';
import 'dart:io';

import 'package:cache_image/cache_image.dart';
import 'package:cooperation/BL/authentication_bl.dart';
import 'package:cooperation/BL/user_bl.dart';
import 'package:cooperation/GUI/edit_profile_gui.dart';
import 'package:cooperation/GUI/log_in_gui.dart';
import 'package:cooperation/localization/AppLocalizations.dart';
import 'package:cooperation/main.dart';
import 'package:flutter/material.dart';

class ProfileGUI extends StatefulWidget {
  @override
  _ProfileGUIState createState() => _ProfileGUIState();
}

class _ProfileGUIState extends State<ProfileGUI> {
  String _photoUrl;
  String _name;

  @override
  void initState() {
    super.initState();
    _photoUrl = UserBL.getPhotoUrl();
    _name = UserBL.getName();
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
                        child: Image(
                          fit: BoxFit.fill,
                          image: CacheImage(UserBL.getPhotoUrl()),
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
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Divider(),
                    ),
                    SizedBox(
                      width: double.maxFinite,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: OutlineButton(
                          borderSide: BorderSide(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.black26
                                    : Colors.white, //Color of the border
                            style: BorderStyle.solid, //Style of the border
                            width: 1, //width of the border
                          ),
                          highlightColor: Colors.blue[100],
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)),
                          onPressed: () {
                            MyApp.changeTheme(context);
                          },
                          child: Text(
                            AppLocalizations().changeLightDarkMode,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.maxFinite,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: OutlineButton(
                          borderSide: BorderSide(
                            color:
                            Theme.of(context).brightness == Brightness.light
                                ? Colors.black26
                                : Colors.white, //Color of the border
                            style: BorderStyle.solid, //Style of the border
                            width: 1, //width of the border
                          ),
                          highlightColor: Colors.blue[100],
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)),
                          onPressed: () {
                            //MyApp.changeTheme(context);
                          },
                          child: Text(
                            AppLocalizations().changeLanguage,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
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
                  borderSide: BorderSide(
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.black26
                        : Colors.white, //Color of the border
                    style: BorderStyle.solid, //Style of the border
                    width: 1, //width of the border
                  ),
                  highlightColor: Colors.blue[100],
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfileGUI(),
                      ),
                    ).then((value) {
                      if (value != null && value) {
                        UserBL.updateCurrentUser().then((value) {
                          if (mounted) {
                            setState(() {
                              _photoUrl = UserBL.getPhotoUrl();
                              _name = UserBL.getName();
                            });
                          }
                        });
                      }
                    });
                  },
                  child: Text(
                    AppLocalizations().editProfile,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Expanded(
                child: OutlineButton(
                  borderSide: BorderSide(
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.black26
                        : Colors.white, //Color of the border
                    style: BorderStyle.solid, //Style of the border
                    width: 1, //width of the border
                  ),
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
                    AppLocalizations().logOut,
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
