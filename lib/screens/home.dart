/* Copyright (C) 2021 Halvor Vivelstad - All Rights Reserved
 You may not use, distribute and modify this code unless a license is granted. 
 If so use, distribution and modification can be done under the terms of the license.*/

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ukeplaner/config/config.dart';
import 'package:ukeplaner/icons/custom_icons.dart';
import 'package:ukeplaner/logic/firebase/auth_services.dart';
import 'package:ukeplaner/logic/firebase/firebase.dart';
import 'package:ukeplaner/screens/login.dart';
import '../logic/tekst.dart';
import 'package:week_of_year/week_of_year.dart';
import 'package:provider/provider.dart';

DateTime now = DateTime.now();

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime date = getDate()["dateTime"];
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(250),
        child: Stack(
          alignment: Alignment.topRight,
          children: [TopDecorationHalfCircle()],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 25),
            child: Text(
              'Mine Planer',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 38, 58, 80),
                letterSpacing: 2,
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Container(
              color: Colors.transparent,
              width: 400,
              height: MediaQuery.of(context).size.width / 1.2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  MenuButton(
                    onPressed: () {
                      currentPageSelected = 0;
                      Navigator.of(context).pushNamed("/dayplan");
                    },
                    color: Color.fromARGB(255, 238, 107, 120),
                    icon: CustomIcons.calendar_check,
                    size: 25,
                    title: "Dagsplan",
                    subTitle: DateFormat("EEEE")
                        .format(getDate(addDays: 0)["dateTime"])
                        .capitalize(),
                    subTitleOnLong:
                        DateFormat(DateFormat.YEAR_ABBR_MONTH_WEEKDAY_DAY)
                            .format(getDate()["dateTime"])
                            .capitalize(),
                  ),
                  MenuButton(
                    onPressed: () {
                      addWeeks = 0;
                      Navigator.of(context).pushNamed('/weekPlan');
                    },
                    size: 25,
                    color: Colors.blue,
                    title: 'Ukeplan',
                    subTitle: 'Uke ${date.weekOfYear.toString()}',
                    icon: CustomIcons.calendar_alt,
                  ),
                  MenuButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/testPlan');
                    },
                    size: 25,
                    color: Colors.yellow,
                    title: 'Prøveplan',
                    subTitle:
                        semesterFormatted(getSemester(semesterEn, semesterTo)),
                    icon: CustomIcons.checklist,
                  ),
                  MaterialButton(
                    onPressed: () {
                      context.read<AuthenticationService>().signOut();
                    },
                    child: Text('logg ut'),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MenuButton extends StatefulWidget {
  const MenuButton({
    Key key,
    this.subTitleOnLong,
    @required this.onPressed,
    @required this.size,
    @required this.color,
    @required this.title,
    @required this.subTitle,
    @required this.icon,
  }) : super(key: key);

  final Function onPressed;
  final double size;
  final Color color;
  final String title;
  final String subTitle;
  final String subTitleOnLong;
  final IconData icon;

  @override
  _MenuButtonState createState() => _MenuButtonState(subTitle: subTitle);
}

class _MenuButtonState extends State<MenuButton> {
  _MenuButtonState({this.subTitle});

  String subTitle;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onPressed();
      },
      onLongPressEnd: (details) {
        if (widget.subTitleOnLong == null) {
          return;
        }
        setState(() {
          if (subTitle == widget.subTitleOnLong) {
            subTitle = widget.subTitle;
          } else {
            subTitle = widget.subTitleOnLong;
          }
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 20, left: 0),
        child: Row(
          children: [
            RawMaterialButton(
              onPressed: null,
              shape: CircleBorder(),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Icon(
                  widget.icon,
                  size: widget.size,
                  color: Colors.white,
                ),
              ),
              fillColor: widget.color,
              elevation: 0,
            ),
            Expanded(
              child: Container(
                color: Colors.transparent,
                height: 55,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 38, 58, 80),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        subTitle,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

Map<String, dynamic> getDate({int addDays = 0, int addWeeks = 0}) {
  int skipDays = addDays;
  int skipWeeks = addWeeks;
  // TODO skip holidays

  DateTime currentDateSchool = DateTime(
    now.year,
    now.month,
    now.day,
    now.hour,
    now.minute,
    now.second,
    now.millisecond,
    now.microsecond,
  );
  currentDateSchool = currentDateSchool.add(Duration(days: (7 * skipWeeks)));
  if (currentDateSchool.hour >= 17) {
    // første parantes setter klokka til 00 neste dag.
    int timeToShift = (24 - currentDateSchool.hour);

    currentDateSchool = currentDateSchool.add(Duration(hours: timeToShift));
    currentDateSchool = DateTime(
      currentDateSchool.year,
      currentDateSchool.month,
      currentDateSchool.day,
      currentDateSchool.hour,
      0,
      0,
      0,
      0,
    );
  }

  currentDateSchool = skipWeekend(currentDateSchool)["dateTime"];

  int weekIndex =
      (currentDateSchool.day - findFirstDateOfTheWeek(currentDateSchool).day) +
          1;

  for (var i = 0; i < skipDays; i++) {
    currentDateSchool = currentDateSchool.add(Duration(days: 1));
    currentDateSchool = skipWeekend(currentDateSchool)["dateTime"];
  }

  weekIndex =
      (currentDateSchool.day - findFirstDateOfTheWeek(currentDateSchool).day) +
          1;

  return {'weekIndex': weekIndex, 'dateTime': currentDateSchool};
}

DateTime findFirstDateOfTheWeek(DateTime dateTime) {
  return dateTime.subtract(Duration(days: dateTime.weekday - 1));
}

DateTime findLastDateOfTheWeek(DateTime dateTime) {
  return dateTime.add(Duration(days: DateTime.daysPerWeek - dateTime.weekday));
}

Map<String, dynamic> skipWeekend(currentDateSchool) {
  int daysSkiped = 0;
  int weekIndex =
      (currentDateSchool.day - findFirstDateOfTheWeek(currentDateSchool).day) +
          1;

  if (weekIndex == 6) {
    // sett dagen til mandag
    weekIndex = 1;
    currentDateSchool = DateTime(
      currentDateSchool.year,
      currentDateSchool.month,
      currentDateSchool.day + 2,
      currentDateSchool.hour,
      0,
      0,
      0,
      0,
    );
    daysSkiped = 2;
  }

  if (weekIndex >= 7) {
    // sett dagen til mandag
    weekIndex = 1;
    currentDateSchool = DateTime(
      currentDateSchool.year,
      currentDateSchool.month,
      currentDateSchool.day + 1,
      currentDateSchool.hour,
      0,
      0,
      0,
      0,
    );
    daysSkiped = 1;
  }
  return {"dateTime": currentDateSchool, "daysSkiped": daysSkiped};
}

String getWeekIndexName(int weekIndex) {
  switch (weekIndex) {
    case 1:
      return "man";
      break;
    case 2:
      return "tir";
      break;
    case 3:
      return "ons";
      break;
    case 4:
      return "tor";
      break;
    case 5:
      return "fre";
      break;
    default:
      return "non";
  }
}
