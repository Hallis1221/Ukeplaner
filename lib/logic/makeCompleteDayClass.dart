Future<List<CompleteDayClass>> makeCompleteDayClass(BuildContext context,
    {@required subjects, @required Map<String, dynamic> dateToShow}) async {
  //TODO implement cache
  List<RoughDayClass> daySubjects = [];
  List<DayClass> daySubjectsFormatted = [];

  List<CompleteDayClass> daySubjectsWithMessagesAndHomework = [];
  print(dateToShow["weekIndex"]);
  for (ClassModel klasse in subjects) {
    for (ClassTime tid in klasse.times) {
      if ((config.currentWeek == "a" && tid.aWeeks) ||
          (config.currentWeek == "b" && tid.bWeeks)) {
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
      DocumentReference documentReference = config.db
          .collection("classes")
          .doc(klasse.classFirestoreID)
          .collection("classes")
          .doc(dateId);
      String message;
      List<Lekse> lekser = [];
      try {
        if (config.classMessagesCache["${klasse.classFirestoreID}.$dateId"] ==
            null) {
          print("object");
          print(
              config.classMessagesCache["${klasse.classFirestoreID}.$dateId"]);
          throw FlutterError(message);
        }
        message =
            config.classMessagesCache["${klasse.classFirestoreID}.$dateId"]
                ["message"]["data"];
        lekser = config.classMessagesCache["${klasse.classFirestoreID}.$dateId"]
            ["lekser"]["data"];
        continue;
      } catch (e) {
        config.analytics
            .logEvent(name: "get_class_${klasse.classFirestoreID}_$dateId");
        print("got_${klasse.classFirestoreID}.$dateId");

        await FirestoreCache.getDocument(documentReference).then((value) {
          try {
            message = value.data()["message"];
            for (var lekse in value.data()["lekser"]) {
              lekser.add(
                new Lekse(
                  tittel: lekse["tittel"],
                  beskrivelse: lekse["desc"],
                  fag: klasse.className,
                  date: dateToShow["dateTime"],
                ),
              );
            }

            config.classMessagesCache[klasse.classFirestoreID.toString()] = {
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
          print(error);
          daySubjectsWithMessagesAndHomework.add(new CompleteDayClass(
              className: "Fri! ",
              startTime: "Hele ",
              endTime: "Dagen",
              homework: [],
              message: "Det er ingen timer satt opp i dag!",
              rom: "Verden!"));
        });
      }

      daySubjectsWithMessagesAndHomework.add(new CompleteDayClass(
          className: klasse.className,
          rom: klasse.rom,
          startTime: klasse.startTime,
          endTime: klasse.endTime,
          message: message,
          lekser: lekser));
    } else if (klasse.classFirestoreID == null) {
      continue;
    }
  }
  if (daySubjectsWithMessagesAndHomework.length == 0) {
    daySubjectsWithMessagesAndHomework.add(new CompleteDayClass(
        className: "Fri! ",
        startTime: "Hele ",
        endTime: "Dagen",
        homework: [],
        message: "Det er ingen timer satt opp i dag!",
        rom: "Verden!"));
  }
  return daySubjectsWithMessagesAndHomework;
}
