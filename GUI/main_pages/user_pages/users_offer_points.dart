import 'dart:io';

import 'package:cooperation/BL/carto_bl.dart';
import 'package:cooperation/BL/points_bl.dart';
import 'package:cooperation/BL/user_bl.dart';
import 'package:cooperation/DB/point.dart';
import 'package:cooperation/localization/AppLocalizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UsersOfferPoints extends StatefulWidget {
  @override
  _UsersOfferPointsState createState() => _UsersOfferPointsState();
}

class _UsersOfferPointsState extends State<UsersOfferPoints> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadPoints(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.separated(
            separatorBuilder: (context, index) => Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
              child: Divider(),
            ),
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) => snapshot.data[index],
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Future<List<Widget>> _loadPoints() async {
    var points = await CartoBL.getUsersOfferPoints(UserBL.getUid());
    List<Widget> widgets = new List();
    for (var point in points) {
      widgets.add(ListItem(point: point));
    }
    return widgets;
  }
}

class ListItem extends StatefulWidget {
  ListItem({@required this.point});
  Point point;

  @override
  _ListItemState createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  bool _isChecked;
  bool isAppleDevice;

  @override
  void initState() {
    super.initState();
    try {
      isAppleDevice = Platform.isIOS || Platform.isMacOS;
    }
    on Exception {
      isAppleDevice = false;
    }
    _isChecked = widget.point.show;
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: EdgeInsets.all(16),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.point.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(widget.point.description),
              ],
            ),
          ),
          Column(
            children: <Widget>[
              Text(AppLocalizations().showQ),
              (isAppleDevice)
                  ? CupertinoSwitch(
                value: _isChecked,
                onChanged: _changeShow,
              )
                  : Switch(
                value: _isChecked,
                onChanged: _changeShow,
              )
            ],
          ),
        ],
      ),
    );
  }

  void _changeShow(bool newValue) {
    widget.point.show = newValue;
    CartoBL.setOfferShow(widget.point.id, newValue);
    if(newValue) {
      PointsBL.offerPoints.addAll({widget.point.id: widget.point});
    } else {
      PointsBL.offerPoints.remove(widget.point.id);
    }
    if(mounted){
      setState(() {
        _isChecked = newValue;
      });
    }
  }
}
