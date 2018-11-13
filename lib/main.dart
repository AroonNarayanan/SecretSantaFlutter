import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:developer';
import 'package:http/http.dart' as http;

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
  bool _startLoadingFamily = false;
  String _passphrase;
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
                  .push(new MaterialPageRoute(builder: (BuildContext context) {
                return Scaffold(
                  appBar: AppBar(
                    title: Text('Your Family'),
                  ),
                  body: _pinScreen(),
                );
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

  Widget _pinScreen() {
    return Column(
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
                Navigator.of(context).push(
                    new MaterialPageRoute(builder: (BuildContext context) {
                  return _familyScreen(passphraseController.text);
                }));
              },
            ),
          ),
        )
      ],
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

class LoginScreenState extends State<LoginScreen> {
  final nameController = TextEditingController();
  final pinController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          child: new Icon(
            Icons.card_giftcard,
            size: 100.0,
            color: Theme.of(context).primaryColor,
          ),
          width: double.infinity,
        ),
        Column(
          children: <Widget>[
            Container(
              height: 50.0,
              constraints: BoxConstraints(maxWidth: 200.0),
              child: TextField(
                decoration: InputDecoration(hintText: 'Your Name'),
                controller: nameController,
              ),
            ),
            Container(
              height: 50.0,
              constraints: BoxConstraints(maxWidth: 200.0),
              child: TextField(
                decoration: InputDecoration(hintText: 'Your PIN'),
                controller: pinController,
                obscureText: true,
                keyboardType: TextInputType.number,
              ),
            ),
            Container(
              constraints: BoxConstraints(maxWidth: 200.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: double.infinity),
                child: RaisedButton(
                  child: Text('Reveal Your Giftee'),
                  onPressed: () {
                    if (nameController.text != "" && pinController.text != "") {
                      _login();
                    } else {
                      final snackBar = SnackBar(
                        content: Text('Oops - we need your name and your PIN.'),
                      );
                      Scaffold.of(context).showSnackBar(snackBar);
                    }
                  },
                ),
              ),
            )
          ],
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
        )
      ],
    );
  }

  void _login() {
    Navigator.of(context)
        .push(new MaterialPageRoute(builder: (BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Secret Santa'),
        ),
        body: Santa(nameController.text, pinController.text),
      );
    }));
  }

  FutureBuilder<Widget> Santa(String name, String pin) {
    return FutureBuilder<Widget>(
      future: _loadSanta(name, pin),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return snapshot.data;
        } else if (snapshot.hasError) {
          return Text('An error occured: \n' + snapshot.error.toString());
        }
        return Container(
          child: CupertinoActivityIndicator(),
          constraints: BoxConstraints(
              minWidth: double.infinity, minHeight: double.infinity),
        );
      },
    );
  }

  Future<Widget> _loadSanta(String name, String pin) async {
    final response = await http.get(
        'https://aroonsecretsanta.azurewebsites.net/getSanta/' +
            name +
            '?pin=' +
            pin);
    if (response.statusCode == 401) {
      return Container(
          constraints: BoxConstraints(
              minWidth: double.infinity, minHeight: double.infinity),
          alignment: Alignment(0.0, 0.0),
          child: Text(
            'We couldn\'t find that name and PIN combination - make sure you typed everything correctly.',
            style: TextStyle(fontSize: 24.0),
            textAlign: TextAlign.center,
          ));
    } else if (response.statusCode == 200) {
      final giftee = json.decode(response.body);
      return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                child: Text('you\'re shopping for',
                    style: TextStyle(fontSize: 24.0)),
                width: double.infinity,
                alignment: Alignment(0.0, 0.0)),
            Text(
              giftee['name'],
              style: TextStyle(fontSize: 80.0),
            ),
            Text(
              'your budget is ' + giftee['budget'],
              style: TextStyle(fontSize: 24.0),
            ),
            Text(
              'have fun!',
              style: TextStyle(fontSize: 24.0),
            )
          ]);
    } else {
      return Text('Error encountered. Please try again.');
    }
  }
}

class LoginScreen extends StatefulWidget {
  @override
  LoginScreenState createState() => new LoginScreenState();
}
