import 'package:flutter/material.dart';
import 'package:ukeplaner/config/config.dart';
import 'package:ukeplaner/logic/class.dart';

class Klasser extends StatelessWidget {
  const Klasser({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("klasser"),
      ),
      body: Column(
        children: [
          for (ClassModel classe in classes)
            ListTile(
              title: Text(
                classe.className,
              ),
              onTap: () => AlertDialog(
                content: Column(
                  children: [
                    Text("Navn: ${classe.className}"),
                    Text("Rom: ${classe.rom}"),
                    Text("Lærer: ${classe.teacher}"),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text("ok"),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }
}
