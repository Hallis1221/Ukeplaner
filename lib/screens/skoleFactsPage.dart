import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:ukeplaner/logic/facts.dart';

class SkoleFacts extends StatelessWidget {
  const SkoleFacts({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Fact> fakta = <Fact>[
      new Fact(
        question: 'text',
        answear: 'text',
        animation: LottieBuilder.asset(
          'assets/animations/UtvAnimasjon.json',
          height: 125,
        ),
      )
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text("Skole Facts"),
      ),
      body: Container(
        child: ListView(
          children: fakta.map((e) => Text(e.question)).toList(),
        ),
      ),
    );
  }
}
