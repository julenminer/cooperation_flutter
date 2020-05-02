import 'package:cached_network_image/cached_network_image.dart';
import 'package:cooperation/BL/firebase_bl.dart';
import 'package:cooperation/BL/user_bl.dart';
import 'package:cooperation/GUI/chat_gui.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Point {
  final int id;
  String title;
  String description;
  double latitude;
  double longitude;
  bool show;
  final String creatorUid;
  final String creatorName;

  Point(
      {this.id,
      this.title,
      this.description,
      this.latitude,
      this.longitude,
      this.show,
      this.creatorUid,
      this.creatorName});

  factory Point.fromJson(Map<String, dynamic> json) {
    var latitude = double.parse(json['latitude'].toString());
    var longitude = double.parse(json['longitude'].toString());

    return Point(
      id: json['cartodb_id'],
      title: json['name'],
      description: json['description'],
      latitude: latitude,
      longitude: longitude,
      show: json['show'],
      creatorUid: json['creator_uid'],
      creatorName: json['creator_name'],
    );
  }

  Marker getMarker(BuildContext context) {
    return new Marker(
      markerId: MarkerId(this.id.toString()),
      position: LatLng(this.latitude, this.longitude),
      infoWindow: InfoWindow(
        title: this.title,
        snippet: this.description,
        onTap: () {
          showModalBottomSheet(
            context: context,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            builder: (context) {
              return SafeArea(
                child: new Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Center(child: Text("Ayuda")),
                      SizedBox(
                        height: 8,
                      ),
                      Divider(
                        thickness: 2,
                      ),
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 40,
                            height: 40,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(40),
                              child: CachedNetworkImage(
                                imageUrl:
                                    FirebaseBL.getUserPhotoUrl(this.creatorUid),
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: Text(
                              this.title,
                              style: TextStyle(
                                fontSize: 18,
                              ),
                              maxLines: 2,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Expanded(
                        child: Scrollbar(
                          child: SingleChildScrollView(
                            child: Text(
                              this.description,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 16,
                              ),
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
                                  borderRadius:
                                      new BorderRadius.circular(30.0)),
                              onPressed: () => Navigator.pop(context),
                              child: Text(
                                "Cerrar",
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
                              borderSide: BorderSide(
                                color: Colors.blue, //Color of the border
                                style: BorderStyle.solid, //Style of the border
                                width: 2, //width of the border
                              ),
                              shape: new RoundedRectangleBorder(
                                  borderRadius:
                                      new BorderRadius.circular(30.0)),
                              onPressed: this.creatorUid == UserBL.getUid() ? null : () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChatGUI(toName: creatorName, toUid: creatorUid,),
                                    ));
                              },
                              child: Text(
                                "Enviar mensaje",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
