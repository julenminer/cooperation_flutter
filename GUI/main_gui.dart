import 'package:cooperation/GUI/add_point_gui.dart';
import 'package:cooperation/GUI/main_pages/chats_list_gui.dart';
import 'package:cooperation/GUI/main_pages/help_gui.dart';
import 'package:cooperation/GUI/main_pages/offer_gui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'main_pages/user_gui.dart';

class MainGUI extends StatefulWidget {
  @override
  _MainGUIState createState() => _MainGUIState();
}

class _MainGUIState extends State<MainGUI> {
  String _title;

  Widget _body;

  int _currentIndex;

  @override
  void initState() {
    _currentIndex = 0;
    _body = _getBody(_currentIndex);
    _title = _getTitle(_currentIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
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
                                _onTabSelected(_currentIndex);
                              }
                            }
                      });
                    },
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 8,
                  )
                ]
              : <Widget>[],
          title: Text(
            _title,
            style: TextStyle(
                fontSize: 26, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        body: _body,
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.black54,
          unselectedItemColor: Colors.black26,
          items: _bottomItems(),
          currentIndex: _currentIndex,
          onTap: _onTabSelected,
        ),
      ),
    );
  }

  /// Given an [index], sets the state of the navigation page.
  void _onTabSelected(int index) {
    if(mounted){
      setState(() {
        _body = _getBody(index);
        _title = _getTitle(index);
        _currentIndex = index;
      });
    }
  }

  /// Returns the items for the bottom navigation bar.
  List<BottomNavigationBarItem> _bottomItems() {
    var list = [
      BottomNavigationBarItem(
        icon: Icon(Icons.help),
        title: Text(_getTitle(0)),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.pan_tool),
        title: Text(_getTitle(1)),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.message),
        title: Text(_getTitle(2)),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person),
        title: Text(_getTitle(3)),
      ),
    ];
    return list;
  }

  /// Given an [index], returns the name of the title.
  String _getTitle(int index) {
    switch (index) {
      case 0:
        return "Ayuda";
        break;
      case 1:
        return "Oferta de ayuda";
        break;
      case 2:
        return "Chat";
        break;
      case 3:
        return "Perfil";
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
