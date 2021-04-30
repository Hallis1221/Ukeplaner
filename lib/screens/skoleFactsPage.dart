import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:ukeplaner/logic/facts.dart';

class SkoleFacts extends StatelessWidget {
  const SkoleFacts({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Fact> faktaer = <Fact>[
      new Fact(
        question: 'Hva er meningen i livet?',
        answear: 'text',
        animation: LottieBuilder.asset(
          'assets/animations/UtvAnimasjon.json',
          height: 125,
        ),
      ),
      new Fact(
        question: 'Hva er meningen med skole?',
        answear: 'text',
        animation: LottieBuilder.asset(
          'assets/animations/UtvAnimasjon.json',
          height: 125,
        ),
      ),
      new Fact(
        question: 'Hvorfor har staten ansvaret for utdanningen din?',
        answear: 'text',
        animation: LottieBuilder.asset(
          'assets/animations/UtvAnimasjon.json',
          height: 125,
        ),
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text("Skole Facts"),
      ),
      body: Container(
        child: ListView(
          children: faktaer
              .map(
                (Fact fakta) => ListTile(
                  title: Text(fakta.question),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => FactPage(
                        fakta: fakta,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class FactPage extends StatelessWidget {
  const FactPage({Key key, @required this.fakta}) : super(key: key);
  final Fact fakta;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Expanded(
          child: Container(
            child: AutoSizeText(
              fakta.question,
              maxLines: 1,
            ),
          ),
        ),
      ),
    );
  }
}
