/* Copyright (C) 2021 Halvor Vivelstad - All Rights Reserved
 You may not use, distribute and modify this code unless a license is granted. 
 If so use, distribution and modification can be done under the terms of the license.*/

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:ukeplaner/logic/firebase/firebase.dart';

FirebaseAnalytics analytics;
bool localDevMode = false;
String website = remoteConfig.getString('skole_nettside');
String schoolName = remoteConfig.getString('skole_navn');
DateTime sEnStart = DateTime(DateTime.now().year, 8, 17);
//her har ikke år noe å si
DateTime sEnSlutt = DateTime(DateTime.now().year, 1, 20);

Map<String, DateTime> semesterEn = {
  "start": sEnStart,
  "slutt": DateTime(getYear(sEnStart, sEnSlutt), 1, 20),
};
Map<String, DateTime> semesterTo = {
  "start": DateTime(DateTime.now().year, 1, 20),
  "slutt": DateTime(DateTime.now().year, 6, 18),
};

int currentSemester = getSemester(semesterEn, semesterTo);

// ?? https://material.io/design/color
// forholdet mellom 0-100 synlighet og alpha 0-255 er 2,55
ThemeData theme = ThemeData(
  // start color
  backgroundColor: Color.fromARGB(255, 244, 243, 249),
  scaffoldBackgroundColor: Color.fromARGB(255, 244, 243, 249),
  primaryColor: Color.fromARGB(255, 79, 68, 255),
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
    centerTitle: true,
  ),
  fontFamily: "NirmalaUI",
  inputDecorationTheme: InputDecorationTheme(
    filled: false,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(
          10,
        ),
      ),
      borderSide: BorderSide(
        color: Color.fromARGB(255, 79, 68, 255),
      ),
    ),
  ),
);

int getYear(DateTime timeone, DateTime timetwo) {
  if (timeone.isBefore(timetwo)) {
    return DateTime.now().year + 1;
  }
  return DateTime.now().year;
}

int getSemester(
    Map<String, DateTime> semesterEn, Map<String, DateTime> semesterTo) {
  if (isCurrentDateInRange(semesterEn["start"], semesterEn["slutt"])) {
    return 1;
  } else if (isCurrentDateInRange(semesterTo["start"], semesterTo["slutt"])) {
    return 2;
  }
}

bool isCurrentDateInRange(DateTime startDate, DateTime endDate) {
  final currentDate = DateTime.now();
  return currentDate.isAfter(startDate) && currentDate.isBefore(endDate);
}
