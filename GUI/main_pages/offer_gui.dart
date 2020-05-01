import 'package:cooperation/BL/points_bl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class OfferGUI extends StatefulWidget {
  @override
  _OfferGUIState createState() => _OfferGUIState();
}

class _OfferGUIState extends State<OfferGUI> {
  Set<Marker> _markers;
  GoogleMapController _mapController;
  CameraPosition _initialCameraPosition;
  LatLng _lastCenter;
  int _frameCount;
  bool _loaded;

  @override
  void initState() {
    super.initState();
    _markers = new Set();
    _loaded = false;
    _frameCount = 0;
    _loadMarkers();
  }

  @override
  Widget build(BuildContext context) {
    if (_loaded) {
      return ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(45),
          topRight: Radius.circular(45),
        ),
        child: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: _initialCameraPosition,
          mapToolbarEnabled: true,
          zoomControlsEnabled: true,
          onMapCreated: (controller) {
            _mapController = controller;
          },
          onCameraMove: (position) {
            _lastCenter = position.target;
            _frameCount++;
            if (_frameCount % 20 == 19) {
              _getMarkers();
            }
          },
          onCameraIdle: () {
            _getMarkers();
          },
          myLocationEnabled: true,
          markers: _markers,
        ),
      );
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  Future<CameraPosition> _loadCameraPosition() async {
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

  Future<void> _getMarkers() async {
    if(_mapController != null) {
      var bounds = await _mapController.getVisibleRegion();
      var zoom = await _mapController.getZoomLevel();
      if(mounted){
        setState(() {
          _markers.clear();
        });
        if (zoom > 12) {
          for (var point in PointsBL.offerPoints.values) {
            if (bounds.contains(LatLng(point.latitude, point.longitude))) {
              if(mounted){
                setState(() {
                  _markers.add(point.getMarker(context));
                });
              }
            }
          }
        } else {
          var count = 0;
          for (var point in PointsBL.offerPoints.values) {
            if (bounds.contains(LatLng(point.latitude, point.longitude))) {
              count++;
            }
          }
          if(mounted){
            setState(() {
              _markers.add(
                new Marker(
                  markerId: MarkerId("cluster"),
                  position: _lastCenter,
                  infoWindow: InfoWindow(title: count.toString()),
                ),
              );
            });
          }
        }
      }
    }
  }

  Future<void> _loadMarkers() async {
    await PointsBL.initOfferPointsIfEmpty();
    _initialCameraPosition = await _loadCameraPosition();
    if (mounted && !_loaded) {
      setState(() {
        _loaded = true;
      });
    }
    _getMarkers();
  }
}
