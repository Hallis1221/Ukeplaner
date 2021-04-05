import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ukeplaner/screens/loadingScreen.dart';
import '../config/config.dart' as config;
import '../config/config.dart';
import '../elements/TopDecorationHalfCircle.dart';
import '../logic/getTests.dart';
import '../logic/tekst.dart';
import '../screens/dayPlan.dart';
import '../logic/test.dart';

class Testplan extends StatelessWidget {
  const Testplan({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List brukteFarger = [];
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(150),
        child: Stack(
          alignment: Alignment.topLeft,
          children: [
            TopDecorationHalfCircle(
                colorOne: config.linearBlue, colorTwo: config.linearGreen),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 75, left: 5),
                    child: Text(
                      "Prøveplan ${semesterFormatted(getSemester(semesterEn, semesterTo))}",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40.0, left: 5.0),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  height: 75,
                  width: 75,
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
      body: FutureBuilder(
        future: getTests(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            List<Test> tests = snapshot.data;
            if (snapshot.hasError) {
              print("error: ${snapshot.error}");
            }
            return Column(
              children: [
                SizedBox(height: 150),
                Expanded(
                  child: ListView(
                    children: [
                      Column(
                        children: tests.map((test) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: TimeCard(
                                startTid: DateFormat(
                                        DateFormat.ABBR_MONTH_WEEKDAY_DAY)
                                    .format(test.date),
                                sluttTid: "",
                                klasseNavn: test.title,
                                message: test.message,
                                rom: "",
                                color: (() {
                                  Random rnd = new Random();
                                  int min = 0, max = lekserColors.length;
                                  int r = min + rnd.nextInt(max - min);
                                  int maxColorsLen = brukteFarger.length;

                                  if (maxColorsLen <= max) {
                                    while (brukteFarger.contains(r)) {
                                      r = min + rnd.nextInt(max - min);
                                    }

                                    brukteFarger.add(r);
                                  }

                                  return lekserColors[r];
                                }())),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                )
              ],
            );
          }
          return LoadingAnimation();
        },
      ),
    );
  }
}
