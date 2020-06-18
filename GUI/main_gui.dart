import 'dart:io';

import 'package:cooperation/GUI/add_point_gui.dart';
import 'package:cooperation/GUI/main_pages/chats_list_gui.dart';
import 'package:cooperation/GUI/main_pages/help_gui.dart';
import 'package:cooperation/GUI/main_pages/offer_gui.dart';
import 'package:cooperation/localization/AppLocalizations.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'main_pages/user_gui.dart';

class MainGUI extends StatefulWidget {
  @override
  _MainGUIState createState() => _MainGUIState();
}

class _MainGUIState extends State<MainGUI> {
  int _currentIndex;

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();


  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    if(!kIsWeb) {
      firebaseCloudMessaging_Listeners();
    }
  }

  void iOS_Permission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
    });
  }

  void firebaseCloudMessaging_Listeners() {
    if (Platform.isIOS) iOS_Permission();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        Flushbar(
          duration: Duration(seconds: 5),
          message: message['notification']['body'],
          backgroundGradient: LinearGradient(
            colors: [Colors.blue, Colors.teal],
          ),
          mainButton: FlatButton(
              child: Icon(
                Icons.keyboard_arrow_right,
                color: Colors.white,
              ),
              onPressed: () {
                _onTabSelected(2, context);
              }),
          backgroundColor: Colors.red,
          boxShadows: [
            BoxShadow(
              color: Colors.blue[800],
              offset: Offset(0.0, 2.0),
              blurRadius: 3.0,
            )
          ],
        )..show(context);
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) async {
        _onTabSelected(2, context);
      },
      onLaunch: (Map<String, dynamic> message) async {
        _onTabSelected(2, context);
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          brightness: Theme.of(context).brightness,
          centerTitle: false,
          automaticallyImplyLeading: false,
          actions: _currentIndex < 2
              ? <Widget>[
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddPointGUI(
                                pointType: _currentIndex == 0
                                    ? PointType.help
                                    : PointType.offer),
                          )).then((value) {
                            if(value != null && value) {
                              if(mounted) {
                                _onTabSelected(_currentIndex, context);
                              }
                            }
                      });
                    },
                    color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
                  ),
                  SizedBox(
                    width: 8,
                  )
                ]
              : <Widget>[],
          title: Text(
            _getTitle(_currentIndex, context),
            style: TextStyle(
                fontSize: 26, color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        body: kIsWeb ? Row(
          children: <Widget>[
            NavigationRail(
              selectedIndex: _currentIndex,
              onDestinationSelected: (val) => _onTabSelected(val, context),
              labelType: NavigationRailLabelType.selected,
              destinations: [
                NavigationRailDestination(
                  icon: Icon(Icons.help),
                  label: Text(_getTitle(0, context)),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.pan_tool),
                  label: Text(_getTitle(1, context)),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.message),
                  label: Text(_getTitle(2, context)),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.person),
                  label: Text(_getTitle(3, context)),
                ),
              ],
            ),
            VerticalDivider(thickness: 1, width: 1),
            // This is the main content.
            Expanded(
              child: _getBody(_currentIndex),
            )
          ],
        ) : _getBody(_currentIndex),
        bottomNavigationBar: kIsWeb ? null : BottomNavigationBar(
          selectedItemColor: Theme.of(context).brightness == Brightness.light ? Colors.black45 : Colors.white,
          unselectedItemColor: Theme.of(context).brightness == Brightness.light ? Colors.black26 : Colors.grey[500],
          items: _bottomItems(context),
          currentIndex: _currentIndex,
          onTap: (val) => _onTabSelected(val, context),
        ),
      ),
    );
  }

  /// Given an [index], sets the state of the navigation page.
  void _onTabSelected(int index, BuildContext context) {
    if(mounted){
      setState(() {
        _currentIndex = index;
      });
    }
  }

  /// Returns the items for the bottom navigation bar.
  List<BottomNavigationBarItem> _bottomItems(BuildContext context) {
    var list = [
      BottomNavigationBarItem(
        icon: Icon(Icons.help),
        title: Text(_getTitle(0, context)),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.pan_tool),
        title: Text(_getTitle(1, context)),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.message),
        title: Text(_getTitle(2, context)),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person),
        title: Text(_getTitle(3, context)),
      ),
    ];
    return list;
  }

  /// Given an [index], returns the name of the title.
  String _getTitle(int index, BuildContext context) {
    switch (index) {
      case 0:
        return AppLocalizations.of(context).help;
        break;
      case 1:
        return AppLocalizations.of(context).helpOffer;
        break;
      case 2:
        return AppLocalizations.of(context).chat;
        break;
      case 3:
        return AppLocalizations.of(context).profile;
        break;
    }
    return null;
  }

  /// Given an [index], sets the corresponding body.
  Widget _getBody(int index) {
    switch (index) {
      case 0:
        return HelpGUI();
        break;
      case 1:
        return OfferGUI();
        break;
      case 2:
        return ChatsListGUI();
        break;
      case 3:
        return UserGUI();
        break;
    }
    return null;
  }
}
