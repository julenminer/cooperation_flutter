import 'dart:ui';

import 'package:cooperation/localization/AppLocalizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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
  prefs.setBool('themeMode', themeMode);
  prefs.setString('languageCode', languageCode);
  final Auth auth = new Auth();
  FirebaseUser firebaseUser = await auth.getCurrentUser();
  if (firebaseUser != null) {
    await UserBL.init(firebaseUser);
  }
  runApp(new MyApp(
    themeMode: themeMode,
    languageCode: languageCode,
  ));
}

class MyApp extends StatefulWidget {
  MyApp({@required this.themeMode, @required this.languageCode})
      : assert(themeMode != null && languageCode != null);
  bool themeMode;
  String languageCode;

  static void changeTheme(BuildContext context) {
    _MyAppState state = context.ancestorStateOfType(TypeMatcher<_MyAppState>());
    if (state != null) {
      state.setState(() {
        state._themeMode = !state._themeMode;
      });
    }
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool('themeMode', state._themeMode);
    });
  }

  static void changeLocale(
      BuildContext context, String languageCode) {
    _MyAppState state = context.ancestorStateOfType(TypeMatcher<_MyAppState>());
    if (state != null) {
      state.setState(() {
        state._languageCode = languageCode;
      });
    }
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('languageCode', state._languageCode);
    });
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  /// false = light, true = dark
  bool _themeMode;
  String _languageCode;

  @override
  initState() {
    super.initState();
    _themeMode = widget.themeMode;
    _languageCode = widget.languageCode;
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
        localizationsDelegates: [
          AppLocalizationsDelegate(),
          // ... app-specific localization delegate[s] here
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en'), // English
          const Locale('es'), // Spanish
          // ... other locales the app supports
        ],
        locale: Locale(_languageCode),
        debugShowCheckedModeBanner: false,
        theme: _getTheme(_themeMode).copyWith(
        ),
        home: home);
  }

  ThemeData _getTheme(bool theme) {
    if (theme) {
      return ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        backgroundColor: Colors.black,
        textTheme: TextTheme(
          headline6: Theme.of(context).textTheme.headline6.copyWith(
              color: Colors.white,
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 1),
          bodyText1: TextStyle(color: Colors.white),
        ),
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
