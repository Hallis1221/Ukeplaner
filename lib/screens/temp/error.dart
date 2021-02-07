import 'package:flutter/material.dart';
import 'package:ukeplaner/widgets/scaffold.dart';

class ErrorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SharedScaffold(
      body: Center(
        child: Text(
          "Something went wrong...",
        ),
      ),
    );
  }
}
