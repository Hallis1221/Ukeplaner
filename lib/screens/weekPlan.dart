import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ukeplaner/config/config.dart';
import 'package:ukeplaner/logic/class.dart';
import 'package:ukeplaner/logic/dayClass.dart';
import 'package:ukeplaner/screens/dayPlan.dart';
import 'package:ukeplaner/screens/login.dart';
import 'home.dart';
import 'package:week_of_year/week_of_year.dart';
import '../logic/tekst.dart';

List brukteFarger = [];

class WeekPlan extends StatelessWidget {
  const WeekPlan({Key key, @required this.subjects}) : super(key: key);
  final List<ClassModel> subjects;
  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];
    for (var i = 1; i <= 5; i++) {
      if (getWeekDateDifference(i, 10).inDays < 0) {
        continue;
      }
      widgets.add(WeekPlanColumn(
        weekplanIndex: i,
        week: 10,
        subjects: subjects,
      ));
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(115),
        child: Stack(
          alignment: Alignment.topLeft,
          children: [TopDecorationHalfCircle()],
        ),
      ),
      body: Column(
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
    );
  }
}

class WeekPlanColumn extends StatelessWidget {
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
  Widget build(BuildContext context) {
    if (getWeekDateDifference(weekplanIndex, week).inDays < 0) {
      return null;
    }
    return Container(
      width: MediaQuery.of(context).size.width / 5,
      child: Column(
        children: [
          SizedBox(
            height: 15,
          ),
          Container(
            child: WeekPlanerTitle(week: week, weekplanIndex: weekplanIndex),
          ),
          SizedBox(
            height: 30,
          ),
          FutureBuilder(
            future: makeCompleteDayClass(
              context,
              dateToShow: getDate(
                addDays: getWeekDateDifference(weekplanIndex, week).inDays,
              ),
              subjects: subjects,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                print(
                  getDate(
                    addDays: getWeekDateDifference(weekplanIndex, week).inDays,
                  ),
                );
                return Expanded(
                  child: ListView(children: [
                    for (CompleteDayClass classe in snapshot.data)
                      WeekPlanBox(
                        title: classe.className,
                        color: (() {
                          Random rnd = new Random();
                          int min = 0, max = cardColors.length;
                          int r = min + rnd.nextInt(max - min);
                          int maxColorsLen = brukteFarger.length;
                          print("max: $max");
                          print("maxColorsLen: $maxColorsLen");
                          if (maxColorsLen <= max) {
                            while (brukteFarger.contains(r)) {
                              r = min + rnd.nextInt(max - min);
                            }
                            print("brukte: $brukteFarger");
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

        print(difference);
        if (difference.inDays < 0) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Du kan bare se datoer i framtiden")));
          return;
        }

        currentPageSelected = difference.inDays;

        Navigator.of(context).pushNamed("/dayplan");
        print("cps: $currentPageSelected");
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

Duration getWeekDateDifference(weekplanIndex, week) {
  DateTime date = DateTime(now.year, 1, 1);

  date = findFirstDateOfTheWeek(date.add(Duration(days: (7 * week))))
      .add(Duration(days: weekplanIndex - 1));
  now = DateTime(
    getDate()["dateTime"].year,
    getDate()["dateTime"].month,
    getDate()["dateTime"].day,
  );
  Duration difference = date.difference(now);
  return difference;
}

class WeekPlanBox extends StatelessWidget {
  const WeekPlanBox({Key key, this.title = "", this.color = Colors.redAccent})
      : super(key: key);

  final String title;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 62,
          height: 128,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Text(title),
        ),
        SizedBox(
          height: 15,
        ),
      ],
    );
  }
}
