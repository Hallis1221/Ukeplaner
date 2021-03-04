import 'package:flutter/material.dart';
import 'package:ukeplaner/logic/classTimes.dart';

class Class {
  String className;
  String rom;

  List<ClassTime> times;

  Class({
    @required this.times,
    @required className,
    @required rom,
  });
}
