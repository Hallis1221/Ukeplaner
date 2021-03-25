/* Copyright (C) 2021 Halvor Vivelstad - All Rights Reserved
 You may not use, distribute and modify this code unless a license is granted. 
 If so use, distribution and modification can be done under the terms of the license.*/

import 'package:introduction_screen/introduction_screen.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ukeplaner/config/config.dart';

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.pushReplacementNamed(context, '/validate');
  }

  Widget _buildImage(String assetName) {
    return Align(
      child: Image.asset('assets/images/$assetName.png', width: 350.0),
      alignment: Alignment.lerp(Alignment.center, Alignment.bottomCenter, 0.5),
    );
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);
    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      pages: [
        PageViewModel(
          title: "Velkommen",
          body:
              'Velkommen til $schoolName ukeplaner. En app for deg som $schoolName elev som organiserer skolehverdagen din.',
          image: _buildImage('logo'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Ukeplan",
          body:
              "Raskt tilgjengelig fra hjemsiden er ukeplanen. I den finner du informasjon om lekser, rom og annen informasjon læreren din har lagt ut.",
          image: _buildImage('logo'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Dagsplan",
          body:
              "Trenger du bare en rask oversikt over dagen i dag? Du finner dagsplanen et klikk unna hjemskjermen. Den gir deg alt det ukeplanen gjør, bare en dag av gangen.",
          image: _buildImage('logo'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Prøveplan",
          body:
              "Sliter du med plutslige prøver? Ikke lenger, vurderingsplanen er lett tilgjenelig og gir deg en rask oversikt over fremtidige prøver.",
          image: _buildImage('logo'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Push varsler",
          body:
              'Har du vanskelig for å huske prøver, lekser og timer på egenhånd? $schoolName ukeplaner har valgfrie push varsler som hjelper deg å huske det før det er for sent.',
          image: _buildImage('logo'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Skolens hjemmeside",
          body:
              "Ønsker du å lære mer om $schoolName? Denne appen er for $schoolName elever, du kan lære mer ved å klikke nedenfor.",
          image: _buildImage('logo'),
          footer: MaterialButton(
            onPressed: () {
              launch(website);
            },
            child: const Text(
              'Skolens hjemmeside',
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.lightBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Gjenta",
          bodyWidget: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text("Klikk ", style: bodyStyle),
                  Icon(Icons.help),
                  Text(" på login skjermen for ", style: bodyStyle),
                ],
              ),
              Text("å åpne introduksjonen på nytt.", style: bodyStyle),
            ],
          ),
          image: _buildImage('logo'),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      skip: const Text('Skip'),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Ferdig', style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
