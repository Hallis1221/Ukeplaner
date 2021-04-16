import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
                      'Prøveplan',
                      style: TextStyle(
                        fontSize: 35,
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

class Terminer extends StatefulWidget {
  const Terminer({
    Key key,
    @required this.tests,
    @required this.brukteFarger,
  }) : super(key: key);

  final List<Test> tests;
  final List brukteFarger;

  @override
  _TerminerState createState() => _TerminerState();
}

class _TerminerState extends State<Terminer> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20),
        Row(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedTermin = 1;
                });
              },
              child: Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 58),
                  child: Text(
                    'Termin 1',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      fontStyle: FontStyle.normal,
                      fontSize: 30,
                      letterSpacing: 1.5,
                      color: (() {
                        if (selectedTermin == 1) {
                          return Color.fromARGB(255, 113, 137, 255);
                        } else {
                          return Color.fromARGB(255, 126, 126, 126);
                        }
                      }()),
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedTermin = 2;
                });
              },
              child: Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 58),
                  child: Text(
                    'Termin 2',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      fontStyle: FontStyle.normal,
                      fontSize: 30,
                      letterSpacing: 1.5,
                      color: (() {
                        if (selectedTermin == 2) {
                          return Color.fromARGB(255, 113, 137, 255);
                        } else {
                          return Color.fromARGB(255, 126, 126, 126);
                        }
                      }()),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 100),
        Expanded(
          child: ListView(
            children: [
              Column(
                children: widget.tests.map((test) {
                  return Padding(
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
                          int maxColorsLen = widget.brukteFarger.length;

                          if (maxColorsLen <= max) {
                            while (widget.brukteFarger.contains(r)) {
                              r = min + rnd.nextInt(max - min);
                            }

                            widget.brukteFarger.add(r);
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
}
