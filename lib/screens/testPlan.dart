import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_cache/firestore_cache.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ukeplaner/config/config.dart' as config;
import 'package:ukeplaner/elements/TopDecorationHalfCircle.dart';
import 'package:ukeplaner/logic/getTests.dart';
import 'package:ukeplaner/screens/dayPlan.dart';
import '../logic/test.dart';
import 'login.dart';

class Testplan extends StatelessWidget {
  const Testplan({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(150),
        child: Stack(
          alignment: Alignment.topLeft,
          children: [
            TopDecorationHalfCircle(
                colorOne: config.linearBlue, colorTwo: config.linearGreen),
            Padding(
              padding: const EdgeInsets.only(top: 60.0, left: 15.0),
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
          if (snapshot.connectionState == ConnectionState.done) {
            List<Test> tests = snapshot.data;
            if (snapshot.hasError) {
              print(snapshot.error);
            }
            return Column(
              children: [
                SizedBox(height: 150),
                Expanded(
                  child: ListView(
                    children: [
                      Column(
                        children: tests.map((test) {
                          return TimeCard(
                            startTid:
                                DateFormat(DateFormat.ABBR_MONTH_WEEKDAY_DAY)
                                    .format(test.date),
                            sluttTid: "",
                            klasseNavn: test.title,
                            message: test.message,
                            rom: "",
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                )
              ],
            );
          }
          return Container();
        },
      ),
    );
  }
}
