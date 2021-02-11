import 'package:flutter/material.dart';
import 'package:ukeplaner/logic/firebase/auth_service.dart';
import 'package:provider/provider.dart';

class ErrorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FlatButton(
          onPressed: () => context.read<AuthenticationService>().signOut(),
          child: Text(
            "Something went wrong...",
          ),
        ),
      ),
    );
  }
}
