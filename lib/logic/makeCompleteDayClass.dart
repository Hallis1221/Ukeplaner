import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../config/config.dart';
import '../logic/firebase/firestore.dart';
import '../logic/tekst.dart';

import 'class.dart';
import 'classTimes.dart';
import 'dayClass.dart';
import 'lekse.dart';

Future<List<CompleteDayClass>> makeCompleteDayClass(BuildContext context,
    {@required subjects, @required Map<String, dynamic> dateToShow}) async {
  List<RoughDayClass> daySubjects = [];
  List<DayClass> daySubjectsFormatted = [];

  List<CompleteDayClass> daySubjectsWithMessagesAndHomework = [];
  for (ClassModel klasse in subjects) {
    for (ClassTime tid in klasse.times) {
      if ((currentWeek == "a" && tid.aWeeks) ||
          (currentWeek == "b" && tid.bWeeks)) {
        if (tid.dayIndex == dateToShow["weekIndex"]) {
          daySubjects.add(new RoughDayClass(
            className: klasse.className,
            startTime: tid.startTime,
            endTime: tid.endTime,
            rom: klasse.rom,
            classFirestoreID: klasse.classFirestoreID,
          ));
        } else {
          // TODO remove

        }
      }
    }
  }

  daySubjects
      .sort((classA, classB) => classA.startTime.compareTo(classB.startTime));
  for (RoughDayClass klasse in daySubjects) {
    daySubjectsFormatted.add(
      new DayClass(
        className: klasse.className,
        rom: klasse.rom,
        startTime: convertDoubleToTime(klasse.startTime),
        endTime: convertDoubleToTime(klasse.endTime),
        classFirestoreID: klasse.classFirestoreID,
      ),
    );
  }
  for (DayClass klasse in daySubjectsFormatted) {
    String dateId =
        "${dateToShow["dateTime"].year}.${dateToShow["dateTime"].month}.${dateToShow["dateTime"].day}";
    /* await context.read<AuthenticationService>().getCurrentUser().then(
          (value) => uid = (value.uid),
        );
*/
    if (klasse.classFirestoreID != null) {
      DocumentReference documentReference = db
          .collection("classes")
          .doc(klasse.classFirestoreID)
          .collection("classes")
          .doc(dateId);
      String message;
      List<Lekse> lekser = [];
      try {
        if (classMessagesCache["${klasse.classFirestoreID}.$dateId"] == null) {
          print(classMessagesCache["${klasse.classFirestoreID}.$dateId"]);
          throw FlutterError(message);
        }
        message = classMessagesCache["${klasse.classFirestoreID}.$dateId"]
            ["message"]["data"];
        lekser = classMessagesCache["${klasse.classFirestoreID}.$dateId"]
            ["lekser"]["data"];
        continue;
      } catch (e) {
        await getDocument(
          documentReference: documentReference,
          timeTrigger: new Duration(
            minutes: 30,
          ),
        ).then((value) {
          try {
            message = value["message"];
            for (var lekse in value["lekser"]) {
              lekser.add(
                new Lekse(
                  tittel: lekse["tittel"],
                  beskrivelse: lekse["desc"],
                  fag: klasse.className,
                  date: dateToShow["dateTime"],
                ),
              );
            }

            classMessagesCache[klasse.classFirestoreID.toString()] = {
              "message": {
                "data": message,
                "stored": true,
              },
              "lekser": {
                "data": lekser,
                "stored": true,
              },
            };
          } catch (e) {
            message = null;
            lekser = [];
          }
        }).onError((error, stackTrace) {
          print("error: $error");
          daySubjectsWithMessagesAndHomework.add(
            new CompleteDayClass(
              className: "Fri! ",
              startTime: "Hele ",
              endTime: "Dagen",
              isFree: true,
              homework: ["free"],
              message: "Det er ingen timer satt opp i dag!",
              rom: "Verden :D",
            ),
          );
        });
      }

      daySubjectsWithMessagesAndHomework.add(
        new CompleteDayClass(
          className: klasse.className,
          rom: klasse.rom,
          startTime: klasse.startTime,
          endTime: klasse.endTime,
          message: message,
          lekser: lekser,
        ),
      );
    } else if (klasse.classFirestoreID == null) {
      continue;
    }
  }
  if (daySubjectsWithMessagesAndHomework.length == 0) {
    daySubjectsWithMessagesAndHomework.add(new CompleteDayClass(
        className: "Fri! ",
        startTime: "Hele ",
        isFree: true,
        endTime: "Dagen",
        homework: ["free", "free"],
        message: "Det er ingen timer satt opp i dag!",
        rom: "Verden :D"));
  }
  return daySubjectsWithMessagesAndHomework;
}
