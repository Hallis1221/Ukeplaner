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

List<String> rowChildrenController = [];
List brukteFarger = [];
Future<List<Widget>> getLekserWidgets(context, subjects, date) async {
  List<Widget> children = [];

  await makeCompleteDayClass(context, subjects: subjects, dateToShow: date)
      .then((value) {
    for (CompleteDayClass completeDayClass in value) {
      for (Lekse lekse in completeDayClass.lekser) {
        brukteFarger = [];
        String uid =
            "${lekse.tittel}.${lekse.fag}.${lekse.date}.${lekse.beskrivelse}";
        if (!rowChildrenController.contains(uid)) {
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
                    Icon(
                      (() {
                        if (iconIndex[lekse.tittel] != null) {
                          return iconIndex[lekse.tittel];
                        } else
                          return iconIndex["default"];
                      }()),
                      color: Colors.white,
                      size: 90,
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
        }
      }
    }
  });
  return children;
}
