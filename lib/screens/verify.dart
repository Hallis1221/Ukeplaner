import 'package:flutter/material.dart';

class VerifyPage extends StatelessWidget {
  const VerifyPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Center(
                  child: Card(
                    elevation: 2,
                    child: ClipPath(
                      child: Container(
                        height: 100,
                        width: 100,
                      ),
                      clipper: ShapeBorderClipper(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          BottomCircle(),
        ],
      ),
    );
  }
}

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
