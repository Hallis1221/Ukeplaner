import 'package:ukeplaner/config/config.dart';
import 'package:ukeplaner/logic/class.dart';

Future<List<ClassModel>> getClasses() async {
  print("classes: $classes");
  return classes;
}
