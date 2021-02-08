import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthenticatonWrapper extends StatelessWidget {
  const AuthenticatonWrapper({
    Key key,
    @required this.loggedin,
    @required this.login,
  }) : super(key: key);
  final Widget loggedin;
  final Widget login;

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    if (firebaseUser != null) {
      return loggedin;
    }
    return Scaffold(
      body: login,
    );
  }
}
