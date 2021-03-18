Map<String, dynamic> getDate({int addDays = 0, int addWeeks = 0}) {
  int skipDays = addDays;
  int skipWeeks = addWeeks;
  // TODO skip holidays

  DateTime currentDateSchool = DateTime(
    now.year,
    now.month,
    now.day,
    now.hour,
    now.minute,
    now.second,
    now.millisecond,
    now.microsecond,
  );
  currentDateSchool = currentDateSchool.add(Duration(days: (7 * skipWeeks)));
  if (currentDateSchool.hour >= 17) {
    // første parantes setter klokka til 00 neste dag.
    int timeToShift = (24 - currentDateSchool.hour);

    currentDateSchool = currentDateSchool.add(Duration(hours: timeToShift));
    currentDateSchool = DateTime(
      currentDateSchool.year,
      currentDateSchool.month,
      currentDateSchool.day,
      currentDateSchool.hour,
      0,
      0,
      0,
      0,
    );
  }

  currentDateSchool = skipWeekend(currentDateSchool)["dateTime"];

  int weekIndex =
      (currentDateSchool.day - findFirstDateOfTheWeek(currentDateSchool).day) +
          1;

  for (var i = 0; i < skipDays; i++) {
    currentDateSchool = currentDateSchool.add(Duration(days: 1));
    currentDateSchool = skipWeekend(currentDateSchool)["dateTime"];
  }

  weekIndex =
      (currentDateSchool.day - findFirstDateOfTheWeek(currentDateSchool).day) +
          1;

  return {'weekIndex': weekIndex, 'dateTime': currentDateSchool};
}

DateTime findFirstDateOfTheWeek(DateTime dateTime) {
  return dateTime.subtract(Duration(days: dateTime.weekday - 1));
}

DateTime findLastDateOfTheWeek(DateTime dateTime) {
  return dateTime.add(Duration(days: DateTime.daysPerWeek - dateTime.weekday));
}

Map<String, dynamic> skipWeekend(currentDateSchool) {
  int daysSkiped = 0;
  int weekIndex =
      (currentDateSchool.day - findFirstDateOfTheWeek(currentDateSchool).day) +
          1;

  if (weekIndex == 6) {
    // sett dagen til mandag
    weekIndex = 1;
    currentDateSchool = DateTime(
      currentDateSchool.year,
      currentDateSchool.month,
      currentDateSchool.day + 2,
      currentDateSchool.hour,
      0,
      0,
      0,
      0,
    );
    daysSkiped = 2;
  }

  if (weekIndex >= 7) {
    // sett dagen til mandag
    weekIndex = 1;
    currentDateSchool = DateTime(
      currentDateSchool.year,
      currentDateSchool.month,
      currentDateSchool.day + 1,
      currentDateSchool.hour,
      0,
      0,
      0,
      0,
    );
    daysSkiped = 1;
  }

  return {"dateTime": currentDateSchool, "daysSkiped": daysSkiped};
}

String getWeekIndexName(int weekIndex) {
  switch (weekIndex) {
    case 1:
      return "man";
      break;
    case 2:
      return "tir";
      break;
    case 3:
      return "ons";
      break;
    case 4:
      return "tor";
      break;
    case 5:
      return "fre";
      break;
    default:
      return "non";
  }
}
