import 'package:flutter/material.dart';
import 'package:ukeplaner/logic/class.dart';

import 'login.dart';

class WeekPlan extends StatelessWidget {
  const WeekPlan({Key key, @required this.dateToShow, @required this.subjects})
      : super(key: key);

  final DateTime dateToShow;
  final List<Class> subjects;

  @override
  Widget build(BuildContext context) {
    for (Class item in subjects) {
      print(dateToShow);
      print(item.rom.toString());
    }
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
                  color: Colors.red,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: ListView(
                        scrollDirection: Axis.vertical,
                        children: subjects.map((klasse) {
                          print(klasse.className);
                          return TimeCard();
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
            Center(
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
              onTap: () => Navigator.pushReplacementNamed(context, '/welcome'),
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
