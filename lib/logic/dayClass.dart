import 'lekse.dart';

class CompleteDayClass {
  String className;
  String rom;
  String message;
  List homework;

  String startTime;
  String endTime;

  List<Lekse> lekser;

  CompleteDayClass({
    this.startTime,
    this.endTime,
    this.className,
    this.rom,
    this.message,
    this.homework,
    this.lekser,
  });
}

class DayClass {
  String className;
  String rom;

  String startTime;
  String endTime;
  String classFirestoreID;

  DayClass({
    this.classFirestoreID,
    this.startTime,
    this.endTime,
    this.className,
    this.rom,
  });
}

class RoughDayClass {
  String className;
  String rom;
  String classFirestoreID;

  double startTime;
  double endTime;

  RoughDayClass({
    this.classFirestoreID,
    this.startTime,
    this.endTime,
    this.className,
    this.rom,
  });
}
