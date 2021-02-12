import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ukeplaner/logic/firebase/auth_service.dart';

RemoteConfig remoteconfig = RemoteConfig.instance as RemoteConfig;

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: MaterialButton(
          onPressed: () => context.read<AuthenticationService>().signOut(),
          child: Text(
            remoteconfig.getString("hjem_tekst"),
          ),
        ),
      ),
    );
  }
}
