import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:ukeplaner/config/config.dart' as config;
import 'package:ukeplaner/elements/daySelector.dart';
import 'package:ukeplaner/logic/class.dart';
import 'package:ukeplaner/logic/classTimes.dart';
import 'package:ukeplaner/logic/dayClass.dart';
import 'package:ukeplaner/logic/firebase/auth_services.dart';
import 'package:ukeplaner/logic/leske.dart';
import 'package:ukeplaner/logic/tekst.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ukeplaner/screens/home.dart';
import 'package:ukeplaner/screens/temp/error.dart';
import 'package:provider/provider.dart';

import 'login.dart';

class DayPlan extends StatefulWidget {
  const DayPlan({Key key, @required this.dateToShow, @required this.subjects})
      : super(key: key);

  final Map<String, dynamic> dateToShow;
  final List<ClassModel> subjects;

  @override
  _DayPlanState createState() => _DayPlanState();
}

Map<String, dynamic> dateToShow;

class _DayPlanState extends State<DayPlan> {
  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController(
        initialScrollOffset:
            125 * double.parse(config.currentPageSelected.toString()),
        keepScrollOffset: true);
    return FutureBuilder(
      future: makeCompleteDayClass(context,
          subjects: widget.subjects,
          dateToShow: (() {
            if (dateToShow != null) {
              return dateToShow;
            } else {
              return widget.dateToShow;
            }
          }())),
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
              child: _AppBar(onTap: () {
                setState(() {});
              }),
            ),
            body: Column(
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 25,
                    ),
                    DaySelector(
                      scrollController: scrollController,
                      parent: this,
                    ),
                    SizedBox(
                      height: 25,
                    ),
                  ],
                ),
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
                                    lekser: [
                                      // TODO make come from the class
                                      new Lekse(
                                          tittel: "Campus oppgaver",
                                          beskrivelse:
                                              "Gjør oppgaver på campus inkrement")
                                    ],
                                    color: (() {
                                      Random rnd = new Random();
                                      int min = 0,
                                          max = config.cardColors.length;
                                      int r = min + rnd.nextInt(max - min);
                                      int maxColorsLen = brukteFarger.length;
                                      if (maxColorsLen >= max) {
                                        while (brukteFarger.contains(r)) {
                                          r = min + rnd.nextInt(max - min);
                                        }
                                        brukteFarger.add(r);
                                      }

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
    {@required subjects, @required Map<String, dynamic> dateToShow}) async {
  List<RoughDayClass> daySubjects = [];
  List<DayClass> daySubjectsFormatted = [];
  List<CompleteDayClass> daySubjectsWithMessagesAndHomework = [];

  for (ClassModel klasse in subjects) {
    for (ClassTime tid in klasse.times) {
      if ((config.currentWeek == "a" && tid.aWeeks) ||
          (config.currentWeek == "b" && tid.bWeeks)) {
        if (tid.dayIndex == dateToShow["weekIndex"]) {
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
  print(dateToShow["weekIndex"]);
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
    String dateId =
        "${dateToShow["dateTime"].year}.${dateToShow["dateTime"].month}.${dateToShow["dateTime"].day}";
    /* await context.read<AuthenticationService>().getCurrentUser().then(
          (value) => uid = (value.uid),
        );
*/
    print(dateId);
    if (klasse.classFirestoreID != null) {
      DocumentReference documentReference = config.db
          .collection("classes")
          .doc(klasse.classFirestoreID)
          .collection("classes")
          .doc(dateId);
      await documentReference.get().then((value) {
        daySubjectsWithMessagesAndHomework.add(new CompleteDayClass(
            className: klasse.className,
            rom: klasse.rom,
            startTime: klasse.startTime,
            endTime: klasse.endTime,
            // TODO change
            message: value.data()["message"]));
      });
    } else if (klasse.classFirestoreID == null) {
      continue;
    }
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
  final List<Lekse> lekser;

  @override
  Widget build(BuildContext context) {
    Widget lekseTekst = Container(
        color: Colors.transparent,
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: lekser
                .map(
                  (e) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      Center(
                        child: ListTile(
                          title: Text(e.tittel),
                          subtitle: Text(e.beskrivelse),
                        ),
                      ),
                    ],
                  ),
                )
                .toList()));
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: Container(
              child: ListTile(
                title: Text("Lekser"),
                subtitle: lekseTekst,
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text("ok"),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(
            35,
          ),
        ),
        width: MediaQuery.of(context).size.width / 1.5,
        child: Padding(
          padding:
              const EdgeInsets.only(top: 5, right: 10, left: 10, bottom: 15),
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
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  const _AppBar({
    Key key,
    this.onTap,
  }) : super(key: key);

  final Function onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();

        print(
          " // TODO animation ",
        );
        if (onTap != null) {
          onTap();
        }
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
