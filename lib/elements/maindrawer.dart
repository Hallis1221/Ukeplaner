import 'package:lottie/lottie.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../config/config.dart';
import 'package:provider/provider.dart';
import '../logic/tekst.dart';
import 'package:url_launcher/url_launcher.dart';
import '../logic/firebase/auth_services.dart';
import 'package:flutter/widgets.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  child: Padding(
                    padding: EdgeInsets.only(top: 50.0),
                    child: FutureBuilder(
                      future: _getUser(context),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          User user = snapshot.data;
                          return Container(
                            color: Colors.transparent,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 50.0,
                                  backgroundImage: NetworkImage(
                                      "https://firebasestorage.googleapis.com/v0/b/kg-ukeplaner.appspot.com/o/Mikail%20hode.jpg?alt=media&token=348324c4-c7f1-4a73-9292-9f69208064b2"),
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Text(
                                  "${firstName.capitalize()} ${lastName.capitalize()}",
                                  style: TextStyle(
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Text(
                                  user.email,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return Container();
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(
              color: Colors.pink,
              child: Column(
                children: [
                  SizedBox(
                    height: 20.0,
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.of(context).pushNamed("/profile");
                    },
                    leading: Icon(
                      Icons.person,
                      color: Colors.black,
                    ),
                    title: Text("Din Profil"),
                  ),
                  ListTile(
                    onTap: () {
                      launch(website);
                    },
                    leading: Icon(
                      Icons.home_filled,
                      color: Colors.black,
                    ),
                    title: Text("Ta meg til skolens nettside"),
                  ),
                  ListTile(
                    onTap: () async {
                      await LaunchApp.openApp(
                        androidPackageName: 'com.microsoft.office.onenote',
                        openStore: true,
                      );
                    },
                    leading: Icon(
                      Icons.book,
                      color: Colors.black,
                    ),
                    title: Text("Åpne onenote"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<User> _getUser(
    BuildContext context,
  ) {
    return context.read<AuthenticationService>().getCurrentUser();
  }
}
