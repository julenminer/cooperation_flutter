import 'dart:io';

import 'package:cooperation/GUI/main_pages/user_pages/profile_gui.dart';
import 'package:cooperation/GUI/main_pages/user_pages/users_help_points_gui.dart';
import 'package:cooperation/GUI/main_pages/user_pages/users_offer_points_gui.dart';
import 'package:cooperation/localization/AppLocalizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserGUI extends StatefulWidget {
  @override
  _UserGUIState createState() => _UserGUIState();
}

class _UserGUIState extends State<UserGUI> with SingleTickerProviderStateMixin {
  List<Widget> _childWidgets = [
    UsersHelpPointsGUI(),
    UsersOfferPointsGUI(),
    ProfileGUI()
  ];
  bool _isAppleDevice;

  //The Widgets that has to be loaded when a tab is selected.
  int _selectedIndex = 0;

  TabController _tabController;
  @override
  void initState() {
    super.initState();
    try {
      _isAppleDevice = Platform.isIOS || Platform.isMacOS;
    }
    on Exception {
      _isAppleDevice = false;
    }
    _tabController = new TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    if (_isAppleDevice) {
      return Container(
        child: SizedBox.expand(
          child: Column(
            children: <Widget>[
              SizedBox(
                width: double.maxFinite,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: CupertinoSlidingSegmentedControl(
                    onValueChanged: (value) {
                      if (mounted) {
                        setState(() {
                          _selectedIndex = value;
                        });
                      }
                    },
                    children: {
                      0: Text(AppLocalizations.of(context).askForHelp),
                      1: Text(AppLocalizations.of(context).offerYourHelp),
                      2: Text(AppLocalizations.of(context).myProfile),
                    },
                    groupValue: _selectedIndex,
                  ),
                ),
              ),
              Expanded(child: _getChildWidget()),
            ],
          ),
        ),
      );
    } else {
      // Android, Mac, Web, Fuchsia
      return Container(
        child: SizedBox.expand(
          child: Column(
            children: <Widget>[
              TabBar(
                controller: _tabController,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.black54,
                tabs: [
                  Tab(
                    text: AppLocalizations.of(context).askForHelp,
                  ),
                  Tab(
                    text: AppLocalizations.of(context).offerYourHelp,
                  ),
                  Tab(
                    text: AppLocalizations.of(context).myProfile,
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: _childWidgets,
                ),
              )
            ],
          ),
        ),
      );
    }
  }

  Widget _getChildWidget() => _childWidgets[_selectedIndex];
}
