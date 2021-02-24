import 'package:fancy_on_boarding/fancy_on_boarding.dart';
import 'package:flutter/material.dart';

var pageList = [
  PageModel(
    color: Colors.blue,
    heroImagePath: 'assets/images/kgLogo.png',
    title: Text(
      'Velkommen',
      style: TextStyle(
        fontWeight: FontWeight.w800,
        color: Colors.white,
        fontSize: 34.0,
      ),
    ),
    body: Text(
      'Velkommen til KG ukeplaner. En app for deg som KG elev som organiserer skolehverdagen din.',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white,
        fontSize: 18.0,
      ),
    ),
    iconImagePath: 'assets/images/kgLogo.png',
  ),
  PageModel(
    color: Colors.blueAccent,
    heroImagePath: 'assets/images/kgLogo.png',
    title: Text(
      'Ukeplan',
      style: TextStyle(
        fontWeight: FontWeight.w800,
        color: Colors.white,
        fontSize: 34.0,
      ),
    ),
    body: Text(
      'Raskt tilgjengelig fra hjemsiden er ukeplanen. I den finner du informasjon om lekser, rom og annen informasjon læreren din har lagt ut.',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white,
        fontSize: 18.0,
      ),
    ),
    iconImagePath: 'assets/images/kgLogo.png',
  ),
  PageModel(
    color: Colors.blueGrey,
    heroImagePath: 'assets/images/kgLogo.png',
    title: Text(
      'Dagsplan',
      style: TextStyle(
        fontWeight: FontWeight.w800,
        color: Colors.white,
        fontSize: 34.0,
      ),
    ),
    body: Text(
      'Trenger du bare en rask oversikt over dagen i dag? Du finner dagsplanen et klikk unna hjemskjermen. Den gir deg alt det ukeplanen gjør, bare en dag av gangen.',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white,
        fontSize: 18.0,
      ),
    ),
    iconImagePath: 'assets/images/kgLogo.png',
  ),
  PageModel(
    color: Colors.lightBlue,
    heroImagePath: 'assets/images/kgLogo.png',
    title: Text(
      'Vurderingsplan',
      style: TextStyle(
        fontWeight: FontWeight.w800,
        color: Colors.white,
        fontSize: 34.0,
      ),
    ),
    body: Text(
      'Sliter du med plutslige prøver? Ikke lenger, vurderingsplanen er lett tilgjenelig og gir deg en rask oversikt over fremtidige prøver.',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white,
        fontSize: 18.0,
      ),
    ),
    iconImagePath: 'assets/images/kgLogo.png',
  ),
  PageModel(
    color: Colors.lightBlueAccent,
    heroImagePath: 'assets/images/kgLogo.png',
    title: Text(
      'Push varsler',
      style: TextStyle(
        fontWeight: FontWeight.w800,
        color: Colors.white,
        fontSize: 34.0,
      ),
    ),
    body: Text(
      'Har du vanskelig for å huske prøver, lekser og timer på egenhånd? KG ukeplaner har valgfrie push varsler som hjelper deg å huske det før det er for sent.',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white,
        fontSize: 18.0,
      ),
    ),
    iconImagePath: 'assets/images/kgLogo.png',
  ),
];
