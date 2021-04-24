import 'package:cloud_firestore/cloud_firestore.dart';
import '../config/config.dart';
import '../logic/firebase/firestore.dart';
import '../logic/test.dart';

Future<List<Test>> getTests() async {
  List<Test> tests = await _getList();
  print("returning tests");
  return tests;
}

Future<List<Test>> _getList() async {
  List<Test> tests = [];
  for (String code in cloudClassesCodes) {
    print(2);
    DocumentReference documentReference = db.collection("classes").doc(code);

    var value = await getDocument(
        documentReference: documentReference,
        timeTrigger: new Duration(hours: 1));

    print("VERID ER $value");
    List currentTest = value["tests"];
    print("tests;  $currentTest");
    for (Map test in currentTest) {
      print("test; $test");
      Timestamp timeStamp = test["date"];
      test.forEach((key, value) {
        print("$key: $value");
      });
      try {
        tests.add(new Test(
            date: timeStamp.toDate(),
            message: test["message"],
            title: test["title"]));
        print("tests list: $tests");
      } catch (e) {
        print("timestamp failed: $timeStamp");
        try {
          tests.add(
            new Test(
              date: test["TIMESTAMP_date"],
              message: test["message"],
              title: test["title"],
            ),
          );
        } catch (e) {
          tests.add(
            new Test(
              date: DateTime.now(),
              message: test["message"],
              title: test["title"],
            ),
          );
        }
      }
    }
  }

  return tests;
}
