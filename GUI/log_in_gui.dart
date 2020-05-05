import 'package:cooperation/BL/user_bl.dart';
import 'package:cooperation/localization/AppLocalizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../BL/authentication_bl.dart';
import "main_gui.dart";

/// [LogInGUI] shows a page with three options to log in.
class LogInGUI extends StatefulWidget {
  /// [auth] to perform the authentication.
  Auth auth = new Auth();

  State<StatefulWidget> createState() => new _LogInGUIState();
}

class _LogInGUIState extends State<LogInGUI> {
  /// Scaffold key is used to show toasts as messages in the app.
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final double _iconWidth = 25.0;
  bool _loading;

  @override
  void initState() {
    super.initState();
    _loading = false;
  }

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        key: _scaffoldKey,extendBodyBehindAppBar: true,
        appBar: AppBar(
          brightness: Brightness.light,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: _loading
            ? new Center(
                child: CircularProgressIndicator(),
              )
            : new Container(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.fromLTRB(40, 40, 40, 30),
                          child: Image.asset(
                            "assets/logo.png",
                            width: 100.0,
                            height: 100.0,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(60, 0, 60, 25.0),
                          child: Text(
                            AppLocalizations().logInAndStart,
                            style: Theme.of(context).textTheme.headline6,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(40, 0, 40, 20),
                          child: _signUpButton(
                              Image.asset("assets/google-logo.png"),
                              AppLocalizations().logInGoogle,
                              Colors.grey[300],
                              Colors.black,
                              _googleLogin),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  /// Calls the Google log in method to authenticate the user. If there is an
  /// error in the authentication process, it will show a message.
  void _googleLogin() {
    if(mounted) {
      setState(() {
        _loading = true;
      });
    }
    String uid;
    widget.auth
        .googleSignIn(Localizations.localeOf(context).languageCode,
            Localizations.localeOf(context).countryCode)
        .then((rUid) {
      uid = rUid;
      if (uid != null) {
        _changeToMain();
      } else {
        if(mounted) {
          setState(() {
            _loading = false;
          });
        }
        final snackBar = SnackBar(
          content: Text(AppLocalizations().errorLogIn),
        );
        _scaffoldKey.currentState.showSnackBar(snackBar);
      }
    }).catchError((error) {
      if(mounted) {
        setState(() {
          _loading = false;
        });
      }
      if (error.toString() == "Unknown") {
        final snackBar = SnackBar(
          content: Text(AppLocalizations().errorLogIn),
        );
        _scaffoldKey.currentState.showSnackBar(snackBar);
      }
    });
  }

  /// Creates a button widget with an icon, a text, a given background color,
  /// a given text color and a function to call when the button is pressed.
  Widget _signUpButton(Image icon, String text, Color buttonColor,
      Color textColor, Function login) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RaisedButton(
        onPressed: () {
          login();
        },
        color: buttonColor,
        padding: EdgeInsets.all(10.0),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: _iconWidth,
                child: icon,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: Text(
                  text,
                  style: TextStyle(color: textColor),
                ),
              )
            ],
          ),
        ),
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
        elevation: 0,
      ),
    );
  }

  /// Changes the page to the Feed (initial page of the app).
  void _changeToMain() {
    widget.auth.getCurrentUser().then((firebaseUser) {
      UserBL.init(firebaseUser);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MainGUI()),
      );
    });
  }
}
