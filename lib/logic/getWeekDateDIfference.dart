import 'package:ukeplaner/logic/dates.dart';

Duration getWeekDateDifference(weekplanIndex, week) {
  DateTime now = DateTime.now();
  DateTime date = DateTime(now.year, 1, 1);

  date = findFirstDateOfTheWeek(date.add(Duration(days: (7 * week))))
      .add(Duration(days: weekplanIndex - 1));
  now = DateTime(
    getDate()["dateTime"].year,
    getDate()["dateTime"].month,
    getDate()["dateTime"].day,
  );

  date = skipWeekend(date)["dateTime"];
  Duration difference = date.difference(now);
  return difference;
}
