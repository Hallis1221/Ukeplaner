import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ukeplaner/screens/loadingScreen.dart';
import '../config/config.dart' as config;
import '../config/config.dart';
import '../elements/TopDecorationHalfCircle.dart';
import '../logic/getTests.dart';
import '../screens/dayPlan.dart';
import '../logic/test.dart';
import 'home.dart';
import 'package:week_of_year/week_of_year.dart';

_TestWidgetsState testWidgetsState;

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
                colorOne: config.linearGreen, colorTwo: config.linearBlue),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 75, left: 5),
                    child: Text(
                      'Prøveplan',
                      style: TextStyle(
                        fontFamily: "Verdana",
                        fontSize: 39,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Divider(
                    color: Colors.white,
                    thickness: 2,
                    endIndent: 130,
                    indent: 130,
                  ),
                  Text(
                    'Uke i dag: ${now.weekOfYear + addWeeks}',
                    style: TextStyle(
                        fontFamily: "Verdana",
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
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
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData == false) {
              print("snapshot: $snapshot");
              return LoadingAnimation();
            }
            List<Test> tests = snapshot.data;

            return Terminer(tests: tests, brukteFarger: brukteFarger);
          }
          return LoadingAnimation();
        },
      ),
    );
  }
}

int selectedTermin = 1;
List<Widget> testWidgetsTerminEn = [];
List<Widget> testWidgetsTerminTo = [];

class Terminer extends StatelessWidget {
  const Terminer({
    Key key,
    @required this.tests,
    @required this.brukteFarger,
  }) : super(key: key);

  final List<Test> tests;
  final List brukteFarger;

  Widget build(BuildContext context) {
    List listDoneTests = [];
    testWidgetsTerminEn = [];
    testWidgetsTerminTo = [];
    tests.forEach((test) {
      if (!listDoneTests.contains(test)) {
        Widget widget = Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: TimeCard(
              startTid: DateFormat(DateFormat.ABBR_MONTH_WEEKDAY_DAY)
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
        if (test.date.isBefore(config.sEnStart)) {
          testWidgetsTerminEn.add(widget);
        } else {
          print("tests termin to added");
          testWidgetsTerminTo.add(widget);
        }
        listDoneTests.add(test);
      }
    });
    return Column(
      children: [
        SizedBox(height: 20),
        Termins(),
        SizedBox(height: 100),
        Expanded(
          child: ListView(
            children: [
              TestWidgets(),
            ],
          ),
        )
      ],
    );
  }
}

class TestWidgets extends StatefulWidget {
  const TestWidgets({
    Key key,
  }) : super(key: key);

  @override
  _TestWidgetsState createState() => _TestWidgetsState();
}

class _TestWidgetsState extends State<TestWidgets> {
  @override
  Widget build(BuildContext context) {
    testWidgetsState = this;
    List<Widget> testWidgets = [];
    if (selectedTermin == 1) {
      testWidgets = testWidgetsTerminEn;
    } else if (selectedTermin == 2) {
      testWidgets = testWidgetsTerminTo;
    }
    print("tests widgets: $testWidgets and termin: $selectedTermin");
    return Container(
      color: Colors.transparent,
      child: Column(
        children: testWidgets,
      ),
    );
  }
}

class Termins extends StatefulWidget {
  const Termins({
    Key key,
  }) : super(key: key);

  @override
  _TerminsState createState() => _TerminsState();
}

class _TerminsState extends State<Termins> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 45,
        ),
        Expanded(
          child: TerminWidget(
            parent: this,
            termin: 1,
          ),
        ),
        Expanded(
          child: TerminWidget(
            parent: this,
            termin: 2,
          ),
        ),
        SizedBox(
          width: 45,
        )
      ],
    );
  }
}

class TerminWidget extends StatelessWidget {
  const TerminWidget({
    Key key,
    @required this.parent,
    @required this.termin,
  }) : super(key: key);
  final _TerminsState parent;
  final int termin;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // ignore: invalid_use_of_protected_member
        parent.setState(() {
          selectedTermin = termin;
        });
        // ignore: invalid_use_of_protected_member
        testWidgetsState.setState(() {
          selectedTermin = termin;
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 0, right: 0),
        child: Text(
          'Termin ' + termin.toString(),
          textAlign: TextAlign.center,
          style: GoogleFonts.roboto(
            fontStyle: FontStyle.normal,
            fontSize: 28,
            letterSpacing: 1.5,
            color: (() {
              if (selectedTermin == termin) {
                return Color.fromARGB(255, 113, 137, 255);
              } else {
                return Color.fromARGB(255, 126, 126, 126);
              }
            }()),
          ),
        ),
      ),
    );
  }
}
