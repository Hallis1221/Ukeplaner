import 'package:ukeplaner/logic/classTimes.dart';

class ClassModel {
  String className;
  String rom;
  String teacher;
  String classFirestoreID;

  List<ClassTime> times;

  ClassModel({
    this.classFirestoreID,
    this.teacher,
    this.times,
    this.className,
    this.rom,
  });
}
