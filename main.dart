import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'BL/authentication_bl.dart';
import 'BL/user_bl.dart';
import 'GUI/log_in_gui.dart';
import 'GUI/main_gui.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool themeMode = (prefs.getBool('themeMode') ?? false);
  String languageCode = (prefs.getString('languageCode') ?? 'en');
  String countryCode = (prefs.getString('countryCode') ?? 'US');
  prefs.setBool('themeMode', themeMode);
  prefs.setString('languageCode', languageCode);
  prefs.setString('countryCode', countryCode);
  final Auth auth = new Auth();
  FirebaseUser firebaseUser = await auth.getCurrentUser();
  if (firebaseUser != null) {
    await UserBL.init(firebaseUser);
  }
  runApp(new MyApp(
    themeMode: themeMode,
    languageCode: languageCode,
    countryCode: countryCode,
  ));}

class MyApp extends StatefulWidget {
  MyApp(
      {@required this.themeMode,
        @required this.languageCode,
        @required this.countryCode})
      : assert(
  themeMode != null && languageCode != null && countryCode != null);
  bool themeMode;
  String languageCode;
  String countryCode;

  static void changeTheme(BuildContext context) {
    _MyAppState state = context.ancestorStateOfType(TypeMatcher<_MyAppState>());
    if(state != null) {
      state.setState(() {
        state._themeMode = !state._themeMode;
      });
    }
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool('themeMode', state._themeMode);
    });
  }

  static void changeLocale(
      BuildContext context, String languageCode, String countryCode) {
    _MyAppState state = context.ancestorStateOfType(TypeMatcher<_MyAppState>());
    if(state != null) {
      state.setState(() {
        state._languageCode = languageCode;
        state._countryCode = countryCode;
      });
    }
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('languageCode', state._languageCode);
      prefs.setString('countryCode', state._countryCode);
    });
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  /// false = light, true = dark
  bool _themeMode;
  String _languageCode;
  String _countryCode;

  @override
  initState() {
    super.initState();
    _themeMode = widget.themeMode;
    _languageCode = widget.languageCode;
    _countryCode = widget.countryCode;
  }

  @override
  Widget build(BuildContext context) {
    Widget home;
    if (UserBL.isLogged()) {
      home = MainGUI();
    } else {
      home = LogInGUI();
    }
    return new MaterialApp(
        builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child),
        title: 'Cooperation',
        locale: Locale(_languageCode, _countryCode),
        supportedLocales: [Locale('en', 'US'), Locale('es', 'ES')],
        debugShowCheckedModeBanner: false,
        theme: _getTheme(_themeMode),
        home: home);
  }

  ThemeData _getTheme(bool theme) {
    if (theme) {
      return ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      );
    } else {
      return ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        backgroundColor: Colors.white,
        textTheme: TextTheme(
          headline6: Theme.of(context).textTheme.headline6.copyWith(
            color: Colors.black,
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 1),
          bodyText1: TextStyle(color: Colors.black),
        ),
        buttonColor: Colors.blue[400],
      );
    }
  }
}
