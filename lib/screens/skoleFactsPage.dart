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
        question: 'Hva er meningen med livet?',
        answear: 'Siden du er elev, er meningen med livet skole',
        animation: LottieBuilder.asset(
          'assets/animations/livetsAnimasjon.json',
          height: 300,
        ),
      ),
      new Fact(
        question: 'Hva er meningen med skole?',
        answear:
            'Meningen med skole er at du kan få jobb og leve ulykkelig resten av livet ditt.',
        animation: LottieBuilder.asset(
          'assets/animations/skolemening.json',
          height: 300,
        ),
      ),
      new Fact(
        question: 'Hvorfor har staten ansvaret for utdanningen din?',
        answear: 'text',
        animation: LottieBuilder.asset(
          'assets/animations/UtvAnimasjon.json',
          height: 300,
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
              .map((Fact fakta) => ListTile(
                    title: Text(fakta.question),
                    onTap: () =>
                        Navigator.of(context).push(_createRoute(fakta)),
                  ))
              .toList(),
        ),
      ),
    );
  }
}

Route _createRoute(Fact fact) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => FactPage(
      fakta: fact,
    ),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(1.0, -1.0);
      var end = Offset.zero;
      var curve = Curves.easeOutCubic;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

class FactPage extends StatelessWidget {
  const FactPage({Key key, @required this.fakta}) : super(key: key);
  final Fact fakta;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          child: AutoSizeText(
            fakta.question,
            maxLines: 1,
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Container(
            child: Center(child: fakta.animation),
          ),
          SizedBox(
            height: 50,
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              child: Text(
                fakta.answear,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Verdana',
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
