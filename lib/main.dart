import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:secret_santa/card/family.dart';
import 'package:secret_santa/models.dart';
import 'package:secret_santa/screen/family.dart';
import 'package:secret_santa/screen/giftee.dart';
import 'package:share/share.dart';

import './login.dart';
import './register.dart';
import './resources.dart';
import 'api.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Strings.secretSanta,
      home: Home(),
      theme: new ThemeData(
          primaryColor: Colors.red,
          accentColor: Colors.redAccent,
          iconTheme: IconThemeData(color: Colors.white)),
    );
  }
}

class Home extends StatefulWidget {
  @override
  HomeState createState() => new HomeState();
}

class HomeState extends State<Home> {
  final passphraseController = TextEditingController();

  @override
  void dispose() {
    passphraseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.secretSanta),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.people),
            tooltip: 'Groups',
            onPressed: () {
              Navigator.of(context).push(
                  new MaterialPageRoute(builder: (BuildContext secondContext) {
                return _pinScreen(secondContext);
              }));
            },
          )
        ],
      ),
      body: LoginScreen(),
    );
  }

  Widget familyScreen(String passphrase) {
    return FutureBuilder<Widget>(
      future: _loadFamily(passphrase),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return snapshot.data;
        } else if (snapshot.hasError) {
          return familyError();
        }
        return Scaffold(
          body: Container(
            child: CupertinoActivityIndicator(),
            constraints: BoxConstraints(
                minWidth: double.infinity, minHeight: double.infinity),
          ),
          appBar: AppBar(title: Text("Loading Group...")),
        );
      },
    );
  }

  Widget _pinScreen(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.groups),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                  new MaterialPageRoute(builder: (BuildContext newPageContext) {
                return RegisterFamilyScreen();
              }));
            },
          )
        ],
      ),
      body: groupLoginScreen(context, passphraseController, () {
        if (passphraseController.text != "") {
          Navigator.of(context)
              .push(new MaterialPageRoute(builder: (BuildContext context) {
            return familyScreen(passphraseController.text);
          }));
        } else {
          final snackBar = SnackBar(
            content: Text(Strings.noGroupIdErr),
          );

          Scaffold.of(context).showSnackBar(snackBar);
        }
      }),
    );
  }

  Future<Widget> _loadFamily(String passphrase) async {
    final response = await loadFamily(passphrase);
    if (response.statusCode == 200) {
      Group family;
      try {
        family = Group.fromJson(json.decode(response.body));
      } catch (e) {
        return familyError();
      }
      return Scaffold(
        body: Container(
          padding: EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0),
          color: Colors.grey[100],
          child: ListView.builder(
              itemCount: family.members.length,
              itemBuilder: (context, i) {
                return familyMemberCardWithPin(family.members[i], () {
                  Clipboard.setData(ClipboardData(text: family.members[i].pin));
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text(Strings.copiedPin),
                  ));
                });
              }),
        ),
        appBar: AppBar(
          title: Text('Group ' + passphrase),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.mobile_screen_share),
              tooltip: Strings.shareTooltip,
              onPressed: () {
                if (family != null) {
                  Share.share(Utils.familyToString(family),
                      subject: Strings.shareSubject);
                }
              },
            )
          ],
        ),
      );
    } else {
      return familyError();
    }
  }
}
