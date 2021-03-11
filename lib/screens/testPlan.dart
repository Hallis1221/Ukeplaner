import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ukeplaner/config/config.dart';
import '../logic/test.dart';

class Testplan extends StatelessWidget {
  const Testplan({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                Text(
                  'Maaz er et geni',
                  style: TextStyle(fontSize: 50),
                ),
                Column(
                  children: tests.map((lekse) {
                    return Text(
                        "Det er en prøve ${DateFormat(DateFormat.ABBR_MONTH_WEEKDAY_DAY).format(lekse.date)}. \n Den har tittelen ${lekse.title} med beskjeden ${lekse.message}");
                  }).toList(),
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
