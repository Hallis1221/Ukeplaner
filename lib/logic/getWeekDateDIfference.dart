import '../logic/dates.dart';

Duration getWeekDateDifference(weekplanIndex, week) {
  DateTime now = DateTime.now();
  DateTime nowDate = now;
  DateTime date = DateTime(now.year, 1, 1);

  date = findFirstDateOfTheWeek(date.add(Duration(days: (7 * week))))
      .add(Duration(days: weekplanIndex - 1));
  nowDate = DateTime(
    getDate()["dateTime"].year,
    getDate()["dateTime"].month,
    getDate()["dateTime"].day,
  );

  date = skipWeekend(date)["dateTime"];
  Duration difference = date.difference(nowDate);
  return difference;
}
