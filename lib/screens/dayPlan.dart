import 'dart:math';

import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:ukeplaner/config/config.dart' as config;
import 'package:ukeplaner/logic/class.dart';
import 'package:ukeplaner/logic/classTimes.dart';
import 'package:ukeplaner/logic/dayClass.dart';
import 'package:ukeplaner/logic/firebase/auth_services.dart';
import 'package:ukeplaner/logic/tekst.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ukeplaner/screens/temp/error.dart';
import 'package:provider/provider.dart';

import 'login.dart';

class DayPlan extends StatelessWidget {
  const DayPlan({Key key, @required this.dateToShow, @required this.subjects})
      : super(key: key);

  final DateTime dateToShow;
  final List<ClassModel> subjects;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: makeCompleteDayClass(context,
          subjects: subjects, dateToShow: dateToShow),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return ErrorPage();
        }
        if (snapshot.connectionState == ConnectionState.done) {
          List<CompleteDayClass> daySubjectsFormatted = snapshot.data;
          List brukteFarger = [];

          return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(120.0),
              child: _AppBar(),
            ),
            body: Column(
              children: [
                SizedBox(height: 100),
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 25,
                        color: Colors.transparent,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: ListView(
                              scrollDirection: Axis.vertical,
                              children: daySubjectsFormatted
                                  .map((CompleteDayClass klasse) {
                                return Padding(
                                  padding: const EdgeInsets.all(25 / 2),
                                  child: TimeCard(
                                    klasseNavn: klasse.className,
                                    rom: klasse.rom,
                                    startTid: klasse.startTime,
                                    sluttTid: klasse.endTime,
                                    message: klasse.message,
                                    color: (() {
                                      Random rnd = new Random();
                                      int min = 0,
                                          max = config.cardColors.length;
                                      int r = min + rnd.nextInt(max - min);
                                      while (brukteFarger.contains(r)) {
                                        r = min + rnd.nextInt(max - min);
                                      }
                                      brukteFarger.add(r);
                                      return config.cardColors[r];
                                    }()),
                                  ),
                                );
                              }).toList()),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        return LoadingFlipping.circle(
          duration: Duration(milliseconds: 750),
        );
      },
    );
  }
}

Future<List<CompleteDayClass>> makeCompleteDayClass(BuildContext context,
    {@required subjects, @required dateToShow}) async {
  List<RoughDayClass> daySubjects = [];
  List<DayClass> daySubjectsFormatted = [];
  List<CompleteDayClass> daySubjectsWithMessagesAndHomework = [];

  for (ClassModel klasse in subjects) {
    for (ClassTime tid in klasse.times) {
      if ((config.currentWeek == "a" && tid.aWeeks) ||
          (config.currentWeek == "b" && tid.bWeeks)) {
        if (tid.dayIndex == dateToShow.day) {
          daySubjects.add(new RoughDayClass(
            className: klasse.className,
            startTime: tid.startTime,
            endTime: tid.endTime,
            rom: klasse.rom,
            classFirestoreID: klasse.classFirestoreID,
          ));
        } else {
          // TODO remove

        }
      }
    }
  }
  daySubjects
      .sort((classA, classB) => classA.startTime.compareTo(classB.startTime));
  for (RoughDayClass klasse in daySubjects) {
    daySubjectsFormatted.add(
      new DayClass(
        className: klasse.className,
        rom: klasse.rom,
        startTime: convertDoubleToTime(klasse.startTime),
        endTime: convertDoubleToTime(klasse.endTime),
        classFirestoreID: klasse.classFirestoreID,
      ),
    );
  }
  for (DayClass klasse in daySubjectsFormatted) {
    DocumentReference documentReference =
        config.db.collection("classes").doc(klasse.classFirestoreID);
    String uid;
    await context.read<AuthenticationService>().getCurrentUser().then(
          (value) => uid = (value.uid),
        );
    print(uid);

    print(documentReference.get());

    daySubjectsWithMessagesAndHomework.add(new CompleteDayClass(
        className: klasse.className,
        rom: klasse.rom,
        startTime: klasse.startTime,
        endTime: klasse.endTime,
        // TODO change
        message: "Dette er en beskjed som kan være lagt ut av læreren."));
  }
  if (daySubjectsWithMessagesAndHomework.length == 0) {
    daySubjectsWithMessagesAndHomework.add(new CompleteDayClass(
        className: "Fri! ",
        startTime: "Hele ",
        endTime: "Dagen",
        homework: [],
        message: "Det er ingen timer satt opp i dag!",
        rom: "Verden!"));
  }
  return daySubjectsWithMessagesAndHomework;
}

class TimeCard extends StatelessWidget {
  const TimeCard({
    Key key,
    this.klasseNavn = "Error",
    this.rom = "Google servers",
    this.startTid = "Right now",
    this.sluttTid = "Who knows",
    this.message = " ",
    this.color = Colors.redAccent,
    this.lekser,
  }) : super(key: key);

  final String klasseNavn;
  final String rom;
  final String startTid;
  final String sluttTid;
  final String message;
  final Color color;
  final List lekser;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(
          35,
        ),
      ),
      width: MediaQuery.of(context).size.width / 1.5,
      child: Padding(
        padding: const EdgeInsets.only(top: 5, right: 10, left: 10, bottom: 15),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                child: Row(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          klasseNavn,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Column(
                          children: [
                            Text(
                              rom,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "$startTid - $sluttTid",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: Text(
                message,
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
            (() {
              if (lekser != null) {
                return Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    (() {
                      if (lekser.length <= 1) {
                        return Text(
                            "Du har ${lekser.length} lekse. Trykk for å se den");
                      } else {
                        return Text(
                            "Du har ${lekser.length} lekser. Trykk for å se de");
                      }
                    }())
                  ],
                );
              } else {
                return SizedBox();
              }
            }()),
          ],
        ),
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  const _AppBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();

        print(
          " // TODO animation ",
        );
      },
      child: Stack(
        alignment: Alignment.topLeft,
        children: [
          TopDecorationHalfCircle(),
          Padding(
            padding: const EdgeInsets.only(top: 60.0, left: 15.0),
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
