import 'package:flutter/material.dart';
import 'package:ukeplaner/logic/facts.dart';

class SkoleFacts extends StatelessWidget {
  const SkoleFacts({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Fact> fakta = <Fact>[];
    return Scaffold(
      appBar: AppBar(
        title: Text("Skole Facts"),
      ),
    );
  }
}
