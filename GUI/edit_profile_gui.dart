import 'dart:io';

import 'package:cache_image/cache_image.dart';
import 'package:cooperation/BL/user_bl.dart';
import 'package:cooperation/localization/AppLocalizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileGUI extends StatefulWidget {
  @override
  _EditProfileGUIState createState() => _EditProfileGUIState();
}

class _EditProfileGUIState extends State<EditProfileGUI> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _localImage;
  File _newImage;
  String _imageUrl;
  String _name;
  bool _loading;
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _imageUrl = UserBL.getPhotoUrl();
    _localImage = false;
    _name = UserBL.getName();
    _controller = new TextEditingController(text: _name);
    _loading = false;
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: _loading,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Theme.of(context).backgroundColor,
          appBar: AppBar(
            brightness: Theme.of(context).brightness,
            iconTheme: IconThemeData(color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white),
            title: Text(
              AppLocalizations.of(context).editProfile,
              style: TextStyle(color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 150,
                            width: 150,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(80),
                              child: Image(
                                fit: BoxFit.fill,
                                image: _localImage
                                    ? FileImage(_newImage)
                                    : CacheImage(_imageUrl),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          OutlineButton(
                            borderSide: BorderSide(
                              color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.black26
                                  : Colors.white, //Color of the border
                              style: BorderStyle.solid, //Style of the border
                              width: 1, //width of the border
                            ),
                            child: Text(AppLocalizations.of(context).editImage),
                            onPressed: _getImage,
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0)),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          TextField(
                            decoration: InputDecoration(labelText: AppLocalizations.of(context).name),
                            controller: _controller,
                            onChanged: (value) {
                              _name = value;
                            },
                          ),
                        ],
                      ),
                    ),
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
                      onPressed: _saveChanges,
                      child: _loading
                          ? LinearProgressIndicator()
                          : Text(
                              AppLocalizations.of(context).saveChanges,
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

  /// Shows a menu to select if the image is going to be taken from the gallery or from the camera.
  void _getImage() {
    if (Platform.isIOS || Platform.isMacOS) {
      var actions = CupertinoActionSheet(
        title: Text(AppLocalizations.of(context).editImage),
        actions: <Widget>[
          CupertinoActionSheetAction(
            onPressed: () {
              _getImageCamera();
              Navigator.pop(context, "Camera");
            },
            child: Text(AppLocalizations.of(context).openCamera),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              _getImageGallery();
              Navigator.pop(context, "Gallery");
            },
            child: Text(AppLocalizations.of(context).openGallery),
          )
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context, "Cancel");
          },
          child: Text(AppLocalizations.of(context).cancel),
        ),
      );

      showCupertinoModalPopup(
          context: context, builder: (BuildContext context) => actions);
    } else {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext bc) {
            return Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.camera_alt),
                      title: new Text(AppLocalizations.of(context).openCamera),
                      onTap: () {
                        _getImageCamera();
                        Navigator.pop(context, "Camera");
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo),
                    title: new Text(AppLocalizations.of(context).openGallery),
                    onTap: () {
                      _getImageGallery();
                      Navigator.pop(context, "Gallery");
                    },
                  ),
                ],
              ),
            );
          });
    }
  }

  /// Opens the image gallery to select an image.
  Future<void> _getImageGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _localImage = true;
      _newImage = image;
    });
  }

  /// Opens the camera to take a photo.
  Future<void> _getImageCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _localImage = true;
      _newImage = image;
    });
  }

  Future<void> _saveChanges() async {
    FocusScope.of(context).requestFocus(new FocusNode());
    if (!_localImage && _name == UserBL.getName()) {
      final snackBar = SnackBar(
        content: Text(AppLocalizations.of(context).noChanges),
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);
    } else {
      setState(() {
        _loading = true;
      });
      UserBL.updateUser(_newImage, (_name == UserBL.getName() ? null : _name))
          .then((e) {
        Navigator.pop(context, true);
      });
    }
  }
}
