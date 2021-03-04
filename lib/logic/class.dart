import 'package:flutter/material.dart';
import 'package:ukeplaner/logic/classTimes.dart';

class ClassModel {
  String className;
  String rom;
  String teacher;

  List<ClassTime> times;

  ClassModel({
    this.teacher,
    this.times,
    this.className,
    this.rom,
  });
}
