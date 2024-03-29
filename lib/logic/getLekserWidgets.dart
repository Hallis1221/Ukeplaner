import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../screens/dayPlan.dart';
import 'package:week_of_year/week_of_year.dart';
import 'tekst.dart';
import 'dayClass.dart';
import 'lekse.dart';
import '../config/config.dart';
import 'makeCompleteDayClass.dart';

List brukteFarger = [];

Future<List<Widget>> getLekserWidgets(context, subjects, date) async {
  List<Widget> children = [];

  await makeCompleteDayClass(context, subjects: subjects, dateToShow: date)
      .then((value) {
    print("classv: $value");

    for (CompleteDayClass completeDayClass in value) {
      for (Lekse lekse in completeDayClass.lekser) {
        // ignore: unrelated_type_equality_checks
        if (lekse == "free") {
          print("free");
          return;
        }
        print("lekse: $lekse");
        brukteFarger = [];
        String uid = "${lekse.tittel}.${lekse.fag}.${lekse.date.day}}";
        if (!rowChildrenController.contains(uid)) {
          print("does not contain $uid");
          rowChildrenController.add(uid);
          children.add(Padding(
            padding: const EdgeInsets.only(left: 7.5, right: 7.5, bottom: 25),
            child: GestureDetector(
              onTap: () => showLekse(
                context,
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: ListTile(
                        title: Text(lekse.tittel),
                        subtitle: Text(lekse.beskrivelse),
                      ),
                    ),
                  ],
                ),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width / 2.2,
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      child: (() {
                        if (iconIndex[lekse.fag.toLowerCase()] != null) {
                          return iconIndex[lekse.fag.toLowerCase()];
                        } else
                          return iconIndex["default"];
                      }()),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      lekse.fag,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 25,
                      ),
                    ),
                    Text(
                      "${DateFormat(DateFormat.WEEKDAY).format(lekse.date).capitalize()} uke ${lekse.date.weekOfYear}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  color: (() {
                    Random rnd = new Random();
                    int min = 0, max = lekserColors.length;
                    int r = min + rnd.nextInt(max - min);
                    int maxColorsLen = brukteFarger.length;

                    if (maxColorsLen <= max) {
                      int i = 10;
                      while (brukteFarger.contains(r) || i == 0) {
                        r = min + rnd.nextInt(max - min);
                        i--;
                      }

                      brukteFarger.add(r);
                    }

                    return lekserColors[r];
                  }()),
                  borderRadius: BorderRadius.circular(
                    35,
                  ),
                ),
              ),
            ),
          ));
        } else {
          print(
              "No homework, controller: $rowChildrenController and lekser: ${completeDayClass.lekser}");
        }
      }
    }
  });
  return children;
}
