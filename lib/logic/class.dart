import 'package:flutter/material.dart';
import 'package:ukeplaner/logic/classTimes.dart';

class ClassModel {
  String className;
  String rom;

  List<ClassTime> times;

  ClassModel({
    this.times,
    this.className,
    this.rom,
  });
}
