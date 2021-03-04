class CompleteDayClass {
  String className;
  String rom;
  String message;
  List homework;

  String startTime;
  String endTime;

  CompleteDayClass({
    this.startTime,
    this.endTime,
    this.className,
    this.rom,
    this.message,
    this.homework,
  });
}

class DayClass {
  String className;
  String rom;

  String startTime;
  String endTime;

  DayClass({
    this.startTime,
    this.endTime,
    this.className,
    this.rom,
  });
}

class RoughDayClass {
  String className;
  String rom;

  double startTime;
  double endTime;

  RoughDayClass({
    this.startTime,
    this.endTime,
    this.className,
    this.rom,
  });
}
