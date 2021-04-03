/* Copyright (C) 2021 Halvor Vivelstad - All Rights Reserved
 You may not use, distribute and modify this code unless a license is granted. 
 If so use, distribution and modification can be done under the terms of the license.*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../icons/custom_icons.dart';
import '../logic/class.dart';

// !! DEV
FirebaseAnalytics analytics;
bool localDevMode = false;
String currentWeek = "a";
var remoteConfig;

// !! ADMIN
String website = remoteConfig.getString('skole_nettside');
String schoolName = remoteConfig.getString('skole_navn');
// semester en
String semesterEnStartMaaned =
    remoteConfig.getString("semester_en_slutt_maaned");

String semesterEnStartDag = remoteConfig.getString("semester_en_start_dag");
String semesterEnSluttMaaned =
    remoteConfig.getString("semester_en_slutt_maaned");
String semesterEnSluttDag = remoteConfig.getString("semester_en_slutt_dag");
// semester to
String semesterToStartMaaned =
    remoteConfig.getString("semester_to_start_maaned");
String semesterToStartDag = remoteConfig.getString("semester_to_start_dag");
String semesterToSluttMaaned =
    remoteConfig.getString("semester_to_slutt_maaned");
String semesterToSluttDag = remoteConfig.getString("semester_to_slutt_dag");

//TODO
List<Map<String, DateTime>> ferier = [];
// !! DESIGN
Color deiligRed = Color.fromARGB(255, 238, 107, 120);
Color mildBlue = Color.fromARGB(255, 101, 135, 227);
Color lysOrange = Color.fromARGB(255, 249, 190, 124);
Color skoleGreen = Color.fromARGB(255, 48, 147, 152);
Color rasmusBlue = Color.fromARGB(255, 132, 183, 239);
Color linearBlue = Color.fromARGB(255, 13, 174, 200);
Color linearGreen = Color.fromARGB(255, 34, 219, 58);

// ?? https://material.io/design/color
// forholdet mellom 0-100 synlighet og alpha 0-255 er 2,55

Map<String, Widget> iconIndex = {
  "UTV": Container(
    height: 50,
    width: 40,
    child: LottieBuilder.asset('assets/Animations/UtvAnimasjon.jason'),
  ),
  "default": Icon(
    CustomIcons.book,
    color: Colors.white,
    size: 90,
  )
};
List<Color> cardColors = [
  Color.fromARGB(255, 254, 216, 176),
  Color.fromARGB(255, 112, 217, 82),
  Color.fromARGB(255, 255, 135, 147),
  Color.fromARGB(255, 255, 242, 125),
  Color.fromARGB(255, 105, 237, 243),
  Color.fromARGB(255, 212, 228, 254),
];
List<Color> lekserColors = [
  Color.fromARGB(255, 48, 147, 152),
  Color.fromARGB(255, 238, 107, 120),
  Color.fromARGB(255, 249, 190, 124),
  Color.fromARGB(255, 101, 135, 227),
  Color.fromARGB(255, 0, 50, 155),
];
ThemeData theme = ThemeData(
  // start color
  backgroundColor: Color.fromARGB(255, 254, 247, 229),
  scaffoldBackgroundColor: Color.fromARGB(255, 254, 247, 229),
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

// !! USE CONFIGS TO GENERATE VALUES
//her har ikke år noe å si
// Semester en
DateTime sEnStart = DateTime(
  DateTime.now().year,
  int.parse(semesterEnStartMaaned),
  int.parse(semesterEnStartDag),
);
DateTime sEnSlutt = DateTime(
  DateTime.now().year,
  int.parse(semesterEnSluttMaaned),
  int.parse(semesterEnSluttDag),
);

// Semester to
DateTime sToStart = DateTime(
  DateTime.now().year,
  int.parse(semesterToStartMaaned),
  int.parse(semesterToStartDag),
);
DateTime sToSlutt = DateTime(
  getYear(sEnStart, sEnSlutt),
  int.parse(semesterToSluttMaaned),
  int.parse(semesterToSluttDag),
);

Map<String, DateTime> semesterEn = {
  "start": sEnStart,
  "slutt": sEnSlutt,
};
Map<String, DateTime> semesterTo = {
  "start": sToStart,
  "slutt": sToSlutt,
};

int currentSemester = getSemester(semesterEn, semesterTo);
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
  return 0;
}

bool isCurrentDateInRange(DateTime startDate, DateTime endDate) {
  final currentDate = DateTime.now();
  return currentDate.isAfter(startDate) && currentDate.isBefore(endDate);
}

Map<String, dynamic> fcmDefaults = <String, dynamic>{
  'hjem_tekst': 'default welcome',
  "skole_navn": "KG",
  "skole_nettside": "https://kg.vgs.no",
  "verifikasjon_tittel": "Verifikasjon",
  "verifikasjon_tekst":
      "Tast Inn Den Fire Sifrete Koden Du Har Fått Av Læreren Din",
  "alltid_vis_intro": false,
  "semester_en_start_maaned": 8,
  "semester_en_start_dag": 17,
  "semester_en_slutt_maaned": 1,
  "semester_en_slutt_dag": 20,
  "semester_to_start_maaned": 1,
  "semester_to_start_dag": 20,
  "semester_to_slutt_maaned": 6,
  "semester_to_slutt_dag": 18,
};
List<dynamic> cloudClassesCodes = [];
List<ClassModel> classes = [];
/*[
  new ClassModel(
    classFirestoreID: "XhL71xpigGpmHXfdUBvX",
    className: "UTV",
    rom: "U21",
    teacher: "emmved",
    times: [
      ClassTime(
        dayIndex: 5,
        startTime: 08.30,
        endTime: 10.00,
        aWeeks: true,
        bWeeks: true,
      ),
      ClassTime(
        dayIndex: 1,
        startTime: 10.00,
        endTime: 11.50,
        aWeeks: true,
        bWeeks: true,
      ),
    ],
  ),
  new ClassModel(
    classFirestoreID: "XhL71xpigGpmHXfdUBvX",
    className: "Matte",
    rom: "U21",
    teacher: "emmved",
    times: [
      ClassTime(
        dayIndex: 5,
        startTime: 10.20,
        endTime: 11.55,
        aWeeks: true,
        bWeeks: true,
      ),
      ClassTime(
        dayIndex: 1,
        startTime: 08.30,
        endTime: 10.00,
        aWeeks: true,
        bWeeks: true,
      ),
    ],
  ),
  new ClassModel(
    className: "Matte",
    rom: "U21",
    teacher: "emmved",
    times: [
      ClassTime(
        dayIndex: 4,
        startTime: 10.20,
        endTime: 11.55,
        aWeeks: true,
        bWeeks: true,
      ),
      ClassTime(
        dayIndex: 1,
        startTime: 12.30,
        endTime: 14.00,
        aWeeks: true,
        bWeeks: true,
      ),
    ],
  )
];*/
bool fetchedClasses = false;
FirebaseFirestore db = FirebaseFirestore.instance;
int currentPageSelected = 0;
Map<String, dynamic> classMessagesCache = {};
int addWeeks = 0;
String firstName;
String lastName;
bool isTeacher = false;
