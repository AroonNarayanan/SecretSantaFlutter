import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Secret Santa',
      home: Home(),
      theme: new ThemeData(primaryColor: Colors.red, accentColor: Colors.white),
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
        title: Text('Secret Santa'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.people),
            onPressed: () {
              Navigator.of(context)
                  .push(new MaterialPageRoute(builder: (BuildContext secondContext) {
                return _pinScreen(secondContext);
              }));
            },
          )
        ],
      ),
      body: LoginScreen(),
    );
  }

  Widget _familyScreen(String passphrase) {
    return Scaffold(
      body: FutureBuilder<Widget>(
        future: _loadFamily(passphrase),
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
        title: Text('Your Family'),
      ),
    );
  }

  Widget _pinScreen(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Family'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            child: new Icon(
              Icons.people,
              size: 100.0,
              color: Theme.of(context).primaryColor,
            ),
            width: double.infinity,
          ),
          Container(
            height: 50.0,
            constraints: BoxConstraints(maxWidth: 200.0),
            child: TextField(
              decoration: InputDecoration(hintText: 'Family ID'),
              controller: passphraseController,
            ),
          ),
          Container(
            constraints: BoxConstraints(maxWidth: 200.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: double.infinity),
              child: RaisedButton(
                child: Text('View Family'),
                onPressed: () {
                  if (passphraseController.text != "") {
                    Navigator.of(context).push(
                        new MaterialPageRoute(builder: (BuildContext context) {
                      return _familyScreen(passphraseController.text);
                    }));
                  } else {
                    final snackBar = SnackBar(
                      content: Text('Oops - we need your Family ID.'),
                    );

                    Scaffold.of(context).showSnackBar(snackBar);
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<Widget> _loadFamily(String passphrase) async {
    final response = await http.get(
        'https://aroonsecretsanta.azurewebsites.net/family' +
            '?hideGiftees=true&familyId=' +
            passphrase);
    if (response.statusCode == 200) {
      final family = json.decode(response.body);
      return ListView.builder(
          itemCount: (family.length * 2),
          itemBuilder: (context, i) {
            if (i.isOdd) {
              return Divider();
            }
            return ListTile(
              title: Text(family[i ~/ 2]['name']),
              trailing: Text('PIN: ' + family[i ~/ 2]['pin']),
            );
          });
    } else {
      return _familyError();
    }
  }

  Widget _familyError() {
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


