import 'package:flutter/material.dart';
import 'package:ukeplaner/logic/oss_license.dart';
import 'package:ukeplaner/main.dart';
import '../logic/tekst.dart';

class SettingsMenu extends StatelessWidget {
  const SettingsMenu({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Innstilinger"),
      ),
      body: Column(
        children: [
          Column(
            children: <ListTile>[
              ListTile(
                leading: Icon(Icons.file_present),
                title: Text(
                  "Lisenser",
                ),
                onTap: () => Navigator.of(context).pushNamed('/licenses'),
              ),
              ListTile(
                leading: Icon(Icons.color_lens),
                title: Text(prefs.getString('theme_preset').capitalize() +
                    " Tema. Trykk for å bytte."),
                onTap: () {
                  parent.setState(() {
                    switch (prefs.getString('theme_preset')) {
                      case "halvor":
                        prefs.setString('theme_preset', "maaz");
                        break;
                      case "maaz":
                        prefs.setString('theme_preset', "halvor");
                        break;
                      default:
                    }
                  });
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
