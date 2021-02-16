import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

FirebaseAnalytics analytics;
bool localDevMode = false;

// ?? https://material.io/design/color
// forholdet mellom 0-100 synlighet og alpha 0-255 er 2,55
ThemeData theme = ThemeData(
  // start color
  backgroundColor: Color.fromARGB(100, 244, 243, 249),
  scaffoldBackgroundColor: Color.fromARGB(100, 244, 243, 249),
  primaryColor: Color.fromARGB(255, 79, 58, 255),
  accentColor: Color.fromARGB(255, 48, 147, 152),
  errorColor: Color.fromARGB(255, 229, 25, 25),
  buttonColor: Color.fromARGB(255, 79, 58, 255),
  shadowColor: Color.fromARGB(255, 126, 180, 238),
  splashColor: Color.fromARGB(255, 24, 20, 93),
  indicatorColor: Color.fromARGB(255, 24, 20, 93),
  hintColor: Color.fromARGB(105, 158, 158, 158),
  // end color
  iconTheme: IconThemeData(opacity: 255),
  appBarTheme: AppBarTheme(
    color: Color.fromARGB(255, 79, 58, 255),
    elevation: 0,
    titleSpacing: 0,
    centerTitle: true,
  ),
  fontFamily: "NirmalaUI", // TODO import Nirmala UI
);
