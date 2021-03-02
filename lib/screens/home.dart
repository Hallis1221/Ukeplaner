/* Copyright (C) 2021 Halvor Vivelstad - All Rights Reserved
 You may not use, distribute and modify this code unless a license is granted. 
 If so use, distribution and modification can be done under the terms of the license.*/

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ukeplaner/config/config.dart';
import 'package:ukeplaner/icons/custom_icons.dart';
import 'package:ukeplaner/screens/login.dart';
import '../logic/tekst.dart';

DateTime now = DateTime.now();

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                      print(semesterFormatted(currentSemester));
                    },
                    color: Color.fromARGB(255, 238, 107, 120),
                    icon: CustomIcons.calendar_check,
                    size: 25,
                    title: "Dagsplan",
                    subTitle: DateFormat("EEEE").format(getDate()).capitalize(),
                    subTitleOnLong:
                        DateFormat(DateFormat.YEAR_ABBR_MONTH_WEEKDAY_DAY)
                            .format(getDate())
                            .capitalize(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  DateTime getDate() {
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
    switch (currentDateSchool.weekday) {
      case 6:
        currentDateSchool = currentDateSchool.add(Duration(days: 2));
        break;
      case 7:
        currentDateSchool = currentDateSchool.add(Duration(days: 1));
        break;
      default:
        currentDateSchool = currentDateSchool;
    }
    print(
        DateFormat(DateFormat.HOUR24_MINUTE_SECOND).format(currentDateSchool));
    return currentDateSchool;
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
      onTap: widget.onPressed,
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
            Container(
              color: Colors.transparent,
              width: 200,
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
            )
          ],
        ),
      ),
    );
  }
}
