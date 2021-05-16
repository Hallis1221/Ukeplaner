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
        answear:
            'På papir har de ikke ansvar for det, men i virkeligheten er de inni hjernen din. Det er ikke du som studerer, det er de som studerer deg!',
        animation: LottieBuilder.asset(
          'assets/animations/staten.json',
          height: 300,
        ),
      ),
      new Fact(
        question: 'Hvorfor lastet du ned denne appen?',
        answear:
            'Du gjorde det for at vi kan spionere på deg. Du aksepterte vilkårene og betingelsene uten å lese dem. Vi kan gjøre hva vi vil med deg. Vi ser på deg akkurat nå gjennom kameraet ditt!',
        animation: LottieBuilder.asset(
          'assets/animations/seeyou.json',
          height: 300,
        ),
      ),
      new Fact(
        question: 'Hvorfor får dere lekser?',
        answear: 'Dere får lekser fordi du ikke fortjener fritiden din!',
        animation: LottieBuilder.asset(
          'assets/animations/lekser.json',
          height: 300,
        ),
      ),
      new Fact(
        question: 'Trykk her',
        answear:
            'Hahahahah! Du ga oss nettop rett til å se alt du gjør på mobilen uansett om du sletter appen!',
        animation: LottieBuilder.asset(
          'assets/animations/haha.json',
          height: 300,
        ),
      ),
      new Fact(
        question: 'Hvorfor får dere Helger?',
        answear:
            'Dere får helgen til å jobbe med skole. Det får 48 timer av oss til å jobbe med skole. Vær takknemlig!!!',
        animation: LottieBuilder.asset(
          'assets/animations/haha.json',
          height: 300,
        ),
      ),
      new Fact(
        question: 'Betyr stemmen din noe?',
        answear:
            'Nei!! Skolen er et Diktatur. Du er irrelevant! Du betalte oss for å være irrelevant. ',
        animation: LottieBuilder.asset(
          'assets/animations/haha.json',
          height: 300,
        ),
      ),
      new Fact(
        question: 'Hva står KG for?',
        answear: 'Det står for KiloGram din idiot!',
        animation: LottieBuilder.asset(
          'assets/animations/haha.json',
          height: 300,
        ),
      ),
      new Fact(
        question: 'Hvorfor får dere gratis internett av oss?',
        answear:
            'Når en bruker er koblet til nettet vårt kontrolerer vi hjernen Hans/hennes #feminisme',
        animation: LottieBuilder.asset(
          'assets/animations/haha.json',
          height: 300,
        ),
      ),
      new Fact(
        question: 'Hvis du vil få 5G, trykk her!',
        answear: 'Hah! 5G står for 5 garanterte måter å miste IQ',
        animation: LottieBuilder.asset(
          'assets/animations/haha.json',
          height: 300,
        ),
      ),
      new Fact(
        question: 'Hvorfor finnes hester',
        answear: 'De finnes for at de kan bli til Lim. Bare søk det opp.',
        animation: LottieBuilder.asset(
          'assets/animations/haha.json',
          height: 300,
        ),
      ),
      new Fact(
        question: 'Hvorfor finnes læreverelse?',
        answear: 'Det er der de øver på å kontrolere deres hjerner',
        animation: LottieBuilder.asset(
          'assets/animations/haha.json',
          height: 300,
        ),
      ),
      new Fact(
        question: 'Hvorfor har vi Nynorsk?',
        answear:
            'Det er i pensumet fitt fordi folk som hater verden må ha et fag de er gode i. Nynorsk elskere er de som er preget av grådighet og hat',
        animation: LottieBuilder.asset(
          'assets/animations/haha.json',
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
      var begin = Offset(0.0, 1.0);
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
