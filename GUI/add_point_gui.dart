import 'package:cooperation/BL/carto_bl.dart';
import 'package:cooperation/BL/points_bl.dart';
import 'package:cooperation/BL/user_bl.dart';
import 'package:cooperation/DB/point.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class AddPointGUI extends StatefulWidget {
  AddPointGUI({@required this.pointType});
  PointType pointType;
  @override
  _AddPointGUIState createState() => _AddPointGUIState();
}

enum PointType { help, offer }

class _AddPointGUIState extends State<AddPointGUI> {
  LatLng _lastPosition;
  Set<Marker> _marker;
  TextEditingController _titleController = new TextEditingController();
  bool _titleValidate = false;

  TextEditingController _descriptionController = new TextEditingController();
  bool _descriptionValidate = false;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _marker = new Set();
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: _isLoading,
      child: GestureDetector(
        onTap: () {
          // call this method here to hide soft keyboard
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          appBar: AppBar(
            brightness: Brightness.light,
            iconTheme: IconThemeData(color: Colors.black),
            title: Text(
              widget.pointType == PointType.help
                  ? "Pedir ayuda"
                  : "Ofrecer ayuda",
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: SafeArea(
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextField(
                    autocorrect: true,
                    controller: _titleController,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                        labelText: 'Título',
                        errorText: _titleValidate
                            ? "El título no puede estar vacío"
                            : null),
                  ),
                  TextField(
                    autocorrect: true,
                    controller: _descriptionController,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                        labelText: 'Descripción',
                        errorText: _descriptionValidate
                            ? "La descripción no puede estar vacía"
                            : null),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    "Ubicación",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: FutureBuilder(
                        future: _getInitialCameraPosition(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return GoogleMap(
                              mapType: MapType.normal,
                              initialCameraPosition: snapshot.data,
                              mapToolbarEnabled: true,
                              zoomControlsEnabled: true,
                              onMapCreated: (controller) {
                                _lastPosition = snapshot.data.target;
                                _updateMarker();
                              },
                              onCameraMove: (position) {
                                _lastPosition = position.target;
                                FocusScope.of(context)
                                    .requestFocus(new FocusNode());
                                _updateMarker();
                              },
                              onTap: (argument) => FocusScope.of(context)
                                  .requestFocus(new FocusNode()),
                              myLocationEnabled: true,
                              markers: _marker,
                            );
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    width: double.maxFinite,
                    child: OutlineButton(
                      highlightColor: Colors.blue[100],
                      borderSide: BorderSide(
                        color: Colors.blue, //Color of the border
                        style: BorderStyle.solid, //Style of the border
                        width: 2, //width of the border
                      ),
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                      onPressed: () {
                        FocusScope.of(context).requestFocus(new FocusNode());
                        if (mounted) {
                          setState(() {
                            _titleValidate = _titleController.text.isEmpty;
                            _descriptionValidate =
                                _descriptionController.text.isEmpty;
                          });
                        }
                        if (!_titleValidate &&
                            !_descriptionValidate &&
                            _lastPosition != null) {
                          if (mounted) {
                            setState(() {
                              _isLoading = true;
                            });
                          }

                          CartoBL.insertPoint(
                                  new Point(
                                    id: -1,
                                    title: _titleController.text,
                                    description: _descriptionController.text,
                                    latitude: _lastPosition.latitude,
                                    longitude: _lastPosition.longitude,
                                    show: true,
                                    creatorUid: UserBL.getUid(),
                                    creatorEmail: UserBL.getEmail(),
                                  ),
                                  widget.pointType)
                              .then((newPoint) {
                            if (widget.pointType == PointType.help) {
                              PointsBL.helpPoints
                                  .addAll({newPoint.id: newPoint});
                            } else {
                              PointsBL.offerPoints
                                  .addAll({newPoint.id: newPoint});
                            }
                            if (mounted) {
                              Navigator.pop(context, true);
                            }
                          });
                        }
                      },
                      child: _isLoading
                          ? LinearProgressIndicator()
                          : Text(
                              "Publicar",
                              style: TextStyle(fontSize: 18),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _updateMarker() {
    if (mounted) {
      setState(() {
        _marker.clear();
        _marker.add(
          new Marker(
            markerId: MarkerId("center"),
            position: _lastPosition,
          ),
        );
      });
    }
  }

  Future<CameraPosition> _getInitialCameraPosition() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    _locationData = await location.getLocation();
    return CameraPosition(
        target: LatLng(_locationData.latitude, _locationData.longitude),
        zoom: 15);
  }
}
