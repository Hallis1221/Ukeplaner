import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ukeplaner/config/config.dart';
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
            TopDecorationHalfCircle(colorOne: linearBlue, colorTwo: linearGreen)
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
                          return Container(
                            height: 250,
                            width: 230,
                            decoration: BoxDecoration(
                              color: rasmusBlue,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(children: [
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    test.title,
                                    style: TextStyle(fontSize: 26),
                                  ),
                                  Expanded(
                                    child: Container(),
                                  ),
                                  Column(
                                    children: [
                                      SizedBox(
                                        height: 50,
                                      ),
                                      Text(DateFormat(
                                              DateFormat.ABBR_MONTH_WEEKDAY_DAY)
                                          .format(test.date)),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                ]),
                              ],
                            ),
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

Future<List<Test>> getTests() async {
  List<Test> tests = [];
  for (String code in cloudClassesCodes) {
    var currentTest;
    DocumentReference documentReference = db.collection("classes").doc(code);
    await documentReference.get().then((value) {
      currentTest = value.data()["tests"];
      for (var test in currentTest) {
        Timestamp timeStamp = test["date"];
        tests.add(new Test(
            date: timeStamp.toDate(),
            message: test["message"],
            title: test["title"]));
      }
    });
  }
  return tests;
}
