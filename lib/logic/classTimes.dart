import 'package:flutter/material.dart';

class ClassTime {
  int dayIndex;
  double startTime;
  double endTime;
  bool aWeeks;
  bool bWeeks;
  ClassTime({
    @required dayIndex,
    @required startTime,
    @required endTime,
    @required aWeeks,
    @required bWeeks,
  });
}
