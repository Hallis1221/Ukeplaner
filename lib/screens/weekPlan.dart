import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ukeplaner/config/config.dart';
import 'package:ukeplaner/screens/login.dart';
import 'home.dart';
import 'package:week_of_year/week_of_year.dart';
import '../logic/tekst.dart';

class WeekPlan extends StatelessWidget {
  const WeekPlan({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            color: Colors.green,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  WeekPlanColumn(
                    weekplanIndex: 1,
                    week: 10,
                  ),
                ]),
          ))
        ],
      ),
    );
  }
}

class WeekPlanColumn extends StatelessWidget {
  const WeekPlanColumn(
      {Key key, @required this.weekplanIndex, @required this.week})
      : super(key: key);

  final int weekplanIndex;
  final int week;
  @override
  Widget build(BuildContext context) {
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
          WeekPlanBox()
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
    return GestureDetector(
      onTap: () {
        DateTime date = DateTime(now.year, 1, 1);

        date =
            findFirstDateOfTheWeek(date.add(Duration(days: (7 * widget.week))))
                .add(Duration(days: widget.weekplanIndex - 1));

        now = DateTime(
          getDate()["dateTime"].year,
          getDate()["dateTime"].month,
          getDate()["dateTime"].day,
        );
        Duration difference = date.difference(now);
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
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              height: 15,
              width: 15,
              color: Colors.transparent,
              child: VerticalDivider(
                thickness: 1.2,
                color: Colors.black,
              ),
            ),
          ),
          Text(getWeekIndexName(widget.weekplanIndex).capitalize()),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              height: 15,
              width: 15,
              color: Colors.transparent,
              child: VerticalDivider(
                thickness: 1.2,
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class WeekPlanBox extends StatelessWidget {
  const WeekPlanBox({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 62,
      height: 128,
      decoration: BoxDecoration(
          color: Colors.yellow,
          borderRadius: BorderRadius.all(Radius.circular(10))),
    );
  }
}
