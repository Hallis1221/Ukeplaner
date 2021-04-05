import 'package:flutter/material.dart';
import 'package:sliver_fab/sliver_fab.dart';

class TopDecorationHalfCircle extends StatelessWidget {
  const TopDecorationHalfCircle({
    Key key,
    this.colorOne = const Color.fromARGB(255, 79, 68, 255),
    this.colorTwo = const Color.fromARGB(255, 79, 68, 255),
    this.title = "",
  }) : super(key: key);
  final Color colorOne;
  final Color colorTwo;
  final String title;
  @override
  Widget build(BuildContext context) {
    return ClipOval(
      clipper: DecorationClipper(context: context),
      child: Container(
        height: 200,
        width: MediaQuery.of(context).size.width * 2,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colorOne,
              colorTwo,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              blurRadius: 10,
              color: Theme.of(context).shadowColor,
            )
          ],
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: Theme.of(context).backgroundColor,
              fontSize: 30,
            ),
          ),
        ),
      ),
    );
  }
}

class DecorationClipper extends CustomClipper<Rect> {
  DecorationClipper({
    @required this.context,
  });
  final BuildContext context;

  Rect getClip(Size size) {
    double width = MediaQuery.of(context).size.width * 1.5;
    return Rect.fromLTWH(0 - width * 0.15, -100, width, 300);
  }

  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}
