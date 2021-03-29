import '../config/config.dart';
import '../logic/class.dart';

Future<List<ClassModel>> getClasses() async {
  print("classes: $classes");
  return classes;
}
