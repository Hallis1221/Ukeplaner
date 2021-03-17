/* Copyright (C) 2021 Halvor Vivelstad - All Rights Reserved
 You may not use, distribute and modify this code unless a license is granted. 
 If so use, distribution and modification can be done under the terms of the license.*/

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:ukeplaner/config/config.dart';
import 'package:ukeplaner/icons/custom_icons.dart';
import 'dayPlan.dart';
import 'package:ukeplaner/logic/class.dart';
import 'package:ukeplaner/logic/classTimes.dart';
import 'package:ukeplaner/logic/dayClass.dart';
import 'package:ukeplaner/logic/firebase/auth_services.dart';
import 'package:ukeplaner/logic/firebase/firebase.dart';
import 'package:ukeplaner/logic/leske.dart';
import 'package:ukeplaner/screens/dayPlan.dart';
import 'package:ukeplaner/screens/login.dart';
import '../logic/tekst.dart';
import 'package:week_of_year/week_of_year.dart';
import 'package:provider/provider.dart';

DateTime now = DateTime.now();

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    Key key,
    @required this.subjects,
  }) : super(key: key);
  final List<ClassModel> subjects;
  @override
  Widget build(BuildContext context) {
    print("HERE!");

    DateTime date = getDate()["dateTime"];
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(150),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            TopDecorationHalfCircle(
              title: "$firstName $lastName",
            )
          ],
        ),
      ),
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              MinePlaner(date: date),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 0,
                      left: 25,
                      bottom: 10,
                      right: 0,
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Lekser',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 38, 58, 80),
                            letterSpacing: 2,
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: RawMaterialButton(
                              onPressed: () {
                                showMaterialModalBottomSheet(
                                  context: context,
                                  builder: (context) => NewLekse(),
                                );
                              },
                              shape: CircleBorder(),
                              child: Padding(
                                padding: const EdgeInsets.all(2.5),
                                child: Icon(
                                  Icons.add,
                                  size: 40,
                                  color: Colors.white,
                                ),
                              ),
                              fillColor: mildBlue,
                              elevation: 0,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  FutureBuilder(
                    future: getClassesFromFirebase(context),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Column(
                          children: [
                            for (ClassModel classe in classes)
                              (() {
                                int childsOnRow = 0;
                                List<Widget> stuffToReturn = [];
                                for (ClassTime time in classe.times) {
                                  for (var i = 0; i < 21; i++) {
                                    var date = getDate(addDays: i);
                                    if (date["dateTime"].weekday ==
                                        time.dayIndex) {
                                      stuffToReturn.add(FutureBuilder(
                                        future: getLekserWidgets(
                                            context, subjects, date),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                                  ConnectionState.done &&
                                              snapshot.hasData) {
                                            List<Widget> rowChildren = [];
                                            List<Widget> columnOfRows = [];
                                            for (Widget widget
                                                in snapshot.data) {
                                              if (childsOnRow <= 2) {
                                                rowChildren.add(widget);
                                              } else {
                                                columnOfRows.add(Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: rowChildren,
                                                ));

                                                rowChildren = [];
                                              }
                                              childsOnRow++;
                                            }
                                            columnOfRows.add(Row(
                                              mainAxisAlignment: (() {
                                                if (rowChildren.length == 1) {
                                                  return MainAxisAlignment
                                                      .start;
                                                } else {
                                                  return MainAxisAlignment
                                                      .spaceEvenly;
                                                }
                                              }()),
                                              children: rowChildren,
                                            ));
                                            print(
                                                "columnOfRows: $columnOfRows");
                                            return Column(
                                              children: columnOfRows,
                                            );
                                          }
                                          return Container();
                                        },
                                      ));
                                    }
                                  }
                                }
                                return Column(
                                  children: stuffToReturn,
                                );
                              }())
                          ],
                        );
                      }
                      return Container();
                    },
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class NewLekse extends StatelessWidget {
  const NewLekse({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: ModalScrollController.of(context),
      child: Container(
        height: MediaQuery.of(context).size.height / 1.2,
        child: Column(
          children: [
            SizedBox(
              height: 15,
            ),
            Text(
              "Ny Lekse",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 38, 58, 80),
                letterSpacing: 2,
              ),
            ),
            (() {
              final node = FocusScope.of(context);
              TextEditingController lekseTitleController =
                  TextEditingController();
              TextEditingController lekseBeskController =
                  TextEditingController();
              return Form(
                child: Column(
                  children: [
                    SizedBox(
                      height: 25,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: FormInputField(
                              controller: lekseTitleController,
                              textInputAction: TextInputAction.done,
                              labelText: "Tittel",
                              hintText: "Lekse tittel",
                              onFinish: () {
                                node.unfocus();
                              },
                              icon: Icon(Icons.title),
                            ),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          KlasseField()
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: FormInputField(
                              controller: lekseBeskController,
                              type: TextInputType.multiline,
                              textInputAction: TextInputAction.done,
                              labelText: "Beskrivelse",
                              hintText: "Lekse beskrivelse",
                              onFinish: () {
                                node.unfocus();
                              },
                              icon: Icon(Icons.title),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }())
          ],
        ),
      ),
    );
  }
}

class KlasseField extends StatefulWidget {
  const KlasseField({
    Key key,
  }) : super(key: key);

  @override
  _KlasseFieldState createState() => _KlasseFieldState();
}

class _KlasseFieldState extends State<KlasseField> {
  String hintText = "Velg klasse";
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      hint: Text(
        hintText,
        style: TextStyle(color: Colors.black),
      ),
      items: classes.map((ClassModel value) {
        return new DropdownMenuItem<String>(
          value: value.className,
          child: new Text(value.className),
        );
      }).toList(),
      onChanged: (String newValue) {
        setState(() {
          this.hintText = newValue;
        });
      },
    );
  }
}

Future<List<Widget>> getLekserWidgets(context, subjects, date) async {
  List<Widget> children = [];
  List brukteFarger = [];
  await makeCompleteDayClass(context, subjects: subjects, dateToShow: date)
      .then((value) {
    for (CompleteDayClass completeDayClass in value) {
      for (Lekse lekse in completeDayClass.lekser) {
        children.add(Padding(
          padding: const EdgeInsets.only(left: 7.5, right: 7.5, bottom: 25),
          child: GestureDetector(
            onTap: () => showLekse(
              context,
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: ListTile(
                      title: Text(lekse.tittel),
                      subtitle: Text(lekse.beskrivelse),
                    ),
                  ),
                ],
              ),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width / 2.2,
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Icon(
                    (() {
                      if (iconIndex[lekse.tittel] != null) {
                        return iconIndex[lekse.tittel];
                      } else
                        return iconIndex["default"];
                    }()),
                    color: Colors.white,
                    size: 90,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    lekse.fag,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),
                  Text(
                    "${DateFormat(DateFormat.WEEKDAY).format(lekse.date).capitalize()} uke ${lekse.date.weekOfYear}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color: (() {
                  Random rnd = new Random();
                  int min = 0, max = lekserColors.length;
                  int r = min + rnd.nextInt(max - min);
                  int maxColorsLen = brukteFarger.length;

                  if (maxColorsLen <= max) {
                    while (brukteFarger.contains(r)) {
                      r = min + rnd.nextInt(max - min);
                    }
                    print("brukte: $brukteFarger");
                    brukteFarger.add(r);
                  }

                  return lekserColors[r];
                }()),
                borderRadius: BorderRadius.circular(
                  35,
                ),
              ),
            ),
          ),
        ));
      }
    }
  });
  return children;
}

class MinePlaner extends StatelessWidget {
  const MinePlaner({
    Key key,
    @required this.date,
  }) : super(key: key);

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5, left: 25),
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
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Container(
            color: Colors.transparent,
            width: 400,
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
                ),
              ],
            ),
          ),
        ),
      ],
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
