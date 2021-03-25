import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ukeplaner/config/config.dart';
import 'package:ukeplaner/elements/TopDecorationHalfCircle.dart';
import 'package:ukeplaner/logic/class.dart';
import 'package:ukeplaner/logic/dates.dart';
import 'package:ukeplaner/logic/dayClass.dart';
import 'package:ukeplaner/logic/getWeekDateDIfference.dart';
import 'package:ukeplaner/logic/makeCompleteDayClass.dart';
import 'home.dart';
import 'package:swipedetector/swipedetector.dart';
import 'package:week_of_year/week_of_year.dart';
import '../logic/tekst.dart';

int totalAmountOfDays = 0;

class WeekPlan extends StatefulWidget {
  const WeekPlan({Key key, @required this.subjects}) : super(key: key);
  final List<ClassModel> subjects;

  @override
  _WeekPlanState createState() => _WeekPlanState();
}

class _WeekPlanState extends State<WeekPlan> {
  @override
  Widget build(BuildContext context) {
    // DateTime date = getDate(addDays: currentPageSelected)["dateTime"];
    List<Widget> widgets = [];
    for (var i = 1; i <= 5; i++) {
      if (getWeekDateDifference(i, now.weekOfYear + addWeeks).inDays < 0) {
        continue;
      }
      widgets.add(WeekPlanColumn(
        weekplanIndex: i,
        week: now.weekOfYear + addWeeks,
        subjects: widget.subjects,
      ));
    }
    totalAmountOfDays = widgets.length;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(125),
        child: Stack(
          alignment: Alignment.topLeft,
          children: [
            TopDecorationHalfCircle(
              colorOne: lysOrange,
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    "Uke ${now.weekOfYear + addWeeks}",
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 60.0, left: 15.0),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  height: 60,
                  width: 70,
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SwipeDetector(
        swipeConfiguration: SwipeConfiguration(
          verticalSwipeMinVelocity: 0.1,
          verticalSwipeMinDisplacement: 0.0,
          verticalSwipeMaxWidthThreshold: 1000.0,
        ),
        onSwipeRight: () {
          if (addWeeks != 0) {
            setState(() {
              addWeeks--;
            });
          }
        },
        onSwipeLeft: () {
          if (addWeeks <= 0) {
            setState(() {
              addWeeks++;
            });
          }
        },
        child: Column(
          children: [
            Expanded(
              child: Container(
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: widgets,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

int daysLeft = 0;

class WeekPlanColumn extends StatefulWidget {
  const WeekPlanColumn(
      {Key key,
      @required this.weekplanIndex,
      @required this.week,
      @required this.subjects})
      : super(key: key);

  final int weekplanIndex;
  final int week;
  final List<ClassModel> subjects;

  @override
  _WeekPlanColumnState createState() => _WeekPlanColumnState();
}

class _WeekPlanColumnState extends State<WeekPlanColumn> {
  @override
  Widget build(BuildContext context) {
    List brukteFarger = [];

    if (getWeekDateDifference(widget.weekplanIndex, widget.week).inDays < 0) {}
    return Container(
      width: MediaQuery.of(context).size.width / 5,
      child: Column(
        children: [
          SizedBox(
            height: 15,
          ),
          Container(
            child: WeekPlanerTitle(
              week: widget.week,
              weekplanIndex: widget.weekplanIndex,
            ),
          ),
          SizedBox(
            height: 30,
          ),
          FutureBuilder(
            future: makeCompleteDayClass(
              context,
              dateToShow: getDate(
                addDays: (() {
                  if (addWeeks != 0) {
                    //TODO

                    return widget.weekplanIndex +
                        (5 - getDate()["dateTime"].weekday);
                  } else {
                    print(
                        getWeekDateDifference(widget.weekplanIndex, widget.week)
                            .inDays);
                    return getWeekDateDifference(
                            widget.weekplanIndex, widget.week)
                        .inDays;
                  }
                }()),
                addWeeks: 0,
              ),
              subjects: widget.subjects,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                List<CompleteDayClass> classes = snapshot.data;

                print(
                    "weekindex: ${widget.weekplanIndex}, length: ${classes.length}");
                return Expanded(
                  child: ListView(children: [
                    for (CompleteDayClass classe in classes)
                      WeekPlanBox(
                        title: classe.className,
                        rom: classe.rom,
                        startTime: classe.startTime,
                        endTime: classe.endTime,
                        color: (() {
                          Random rnd = new Random();
                          int min = 0, max = cardColors.length;
                          int r = min + rnd.nextInt(max - min);
                          int maxColorsLen = brukteFarger.length;

                          if (maxColorsLen <= max) {
                            while (brukteFarger.contains(r)) {
                              r = min + rnd.nextInt(max - min);
                            }

                            brukteFarger.add(r);
                          }

                          return cardColors[r];
                        }()),
                      )
                  ]),
                );
              }
              return Container();
            },
          )
        ],
      ),
    );
  }
}

class WeekPlanerTitle extends StatefulWidget {
  const WeekPlanerTitle({
    Key key,
    @required this.week,
    @required this.weekplanIndex,
  }) : super(key: key);

  final int week;
  final int weekplanIndex;

  @override
  _WeekPlanerTitleState createState() => _WeekPlanerTitleState();
}

class _WeekPlanerTitleState extends State<WeekPlanerTitle> {
  @override
  Widget build(BuildContext context) {
    Duration difference =
        getWeekDateDifference(widget.weekplanIndex, widget.week);
    return GestureDetector(
      onTap: () {
        difference = getWeekDateDifference(widget.weekplanIndex, widget.week);

        if (difference.inDays < 0) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Du kan bare se datoer i framtiden")));
          return;
        }
        int tempWeeks;
        if (0 >= addWeeks) {
          tempWeeks = 0;
        } else {
          tempWeeks = addWeeks;
        }

        currentPageSelected = difference.inDays + (tempWeeks * -2);

// TODO denne feil beregner
        Navigator.of(context).pushNamed("/dayplan");
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            getWeekIndexName(widget.weekplanIndex).capitalize(),
            style: TextStyle(
              fontSize: double.parse((() {
                if (difference.inDays == 0) {
                  return 23;
                } else
                  return 22;
              }())
                  .toString()),
              color: (() {
                if (difference.inDays == 0) {
                  return Color.fromARGB(255, 113, 137, 255);
                } else
                  return Color.fromARGB(255, 126, 126, 126);
              }()),
            ),
          ),
        ],
      ),
    );
  }
}

class WeekPlanBox extends StatelessWidget {
  const WeekPlanBox({
    Key key,
    this.color = Colors.redAccent,
    this.title = "",
    this.rom = "",
    this.startTime = "",
    this.endTime = "",
  }) : super(key: key);

  final String title;
  final String rom;
  final String startTime;
  final String endTime;

  final Color color;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.parse((300 - (46 * totalAmountOfDays)).toString()),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.black87,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "$startTime - $endTime",
                  style: TextStyle(
                    fontSize: 13,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  rom,
                  style: TextStyle(
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 15,
        ),
      ],
    );
  }
}
