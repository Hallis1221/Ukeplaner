import 'package:flutter/material.dart';

class BottomCircle extends StatelessWidget {
  const BottomCircle({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        boxShadow: <BoxShadow>[
          BoxShadow(
            blurRadius: 10,
            color: Theme.of(context).shadowColor,
          )
        ],
        borderRadius: BorderRadius.vertical(
          top: Radius.elliptical(
            MediaQuery.of(context).size.width * 3,
            250,
          ),
        ),
      ),
    );
  }
}
