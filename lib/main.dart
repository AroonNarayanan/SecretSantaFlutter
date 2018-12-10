import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './login.dart';
import './resources.dart';
import './register.dart';
import 'package:flutter/services.dart';

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

  static Widget familyScreen(String passphrase) {
    return Scaffold(
      body: FutureBuilder<Widget>(
        future: loadFamily(passphrase),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data;
          } else if (snapshot.hasError) {
            return _familyError();
          }
          return Container(
            child: CupertinoActivityIndicator(),
            constraints: BoxConstraints(
                minWidth: double.infinity, minHeight: double.infinity),
          );
        },
      ),
      appBar: AppBar(
        title: Text('Group ' + passphrase),
//        actions: <Widget>[
//          IconButton(
//            icon: Icon(Icons.delete),
//            onPressed: () {},
//          )
//        ],
      ),
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
      body: Container(
        color: Colors.grey[100],
        alignment: AlignmentDirectional.center,
        child: Card(
          elevation: 2.0,
          child: Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  child: new Icon(
                    Icons.people,
                    size: 100.0,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Container(
                  width: 200.0,
                  child: TextField(
                    decoration: InputDecoration(hintText: 'Group ID'),
                    controller: passphraseController,
                  ),
                ),
                Container(
                  width: 200.0,
                  margin: EdgeInsets.only(top:5.0),
                  child: Builder(builder: (BuildContext context) {
                    return RaisedButton(
                      child: Text('View Group'),
                      onPressed: () {
                        if (passphraseController.text != "") {
                          Navigator.of(context).push(new MaterialPageRoute(
                              builder: (BuildContext context) {
                            return familyScreen(passphraseController.text);
                          }));
                        } else {
                          final snackBar = SnackBar(
                            content: Text('Oops - we need your Group ID.'),
                          );

                          Scaffold.of(context).showSnackBar(snackBar);
                        }
                      },
                    );
                  }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Future<Widget> loadFamily(String passphrase) async {
    final response = await http.get(
        'https://aroonsecretsanta.azurewebsites.net/family' +
            '?hideGiftees=true&familyId=' +
            passphrase);
    if (response.statusCode == 200) {
      var family;
      try {
        family = json.decode(response.body);
      } catch (e) {
        return _familyError();
      }
      return Container(
        margin: EdgeInsets.only(top: 5.0, left: 15.0, right: 15.0),
        color: Colors.grey[100],
        child: ListView.builder(
            itemCount: family.length,
            itemBuilder: (context, i) {
              return Card(
                elevation: 2.0,
                child: ListTile(
                  title: Text(family[i]['name']),
                  subtitle: Text('PIN: ' + family[i]['pin']),
                  onLongPress: () {
                    Clipboard.setData(ClipboardData(text: family[i]['pin']));
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text('PIN copied to clipboard.'),
                    ));
                  },
                ),
              );
            }),
      );
    } else {
      return _familyError();
    }
  }

  static Widget _familyError() {
    return Container(
        constraints: BoxConstraints(
            minWidth: double.infinity, minHeight: double.infinity),
        alignment: Alignment(0.0, 0.0),
        child: Text(
          'We could\'t load your family. Do you have the right password?',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24.0),
        ));
  }
}
