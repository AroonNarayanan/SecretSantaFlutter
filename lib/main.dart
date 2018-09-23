import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Secret Santa',
      home: LoginScreen(),
      theme: new ThemeData(primaryColor: Colors.red, accentColor: Colors.white),
    );
  }
}

class LoginScreenState extends State<LoginScreen> {
  bool _startLoadingSanta = false;
  String _name;
  String _pin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Secret Santa'),
          actions: <Widget>[
            IconButton(
              icon: new Icon(Icons.refresh),
              color: Theme.of(context).accentColor,
              onPressed: () {
                setState(() {
                  _startLoadingSanta = false;
                });
              },
            )
          ],
        ),
        body: _startLoadingSanta ? Santa(_name, _pin) : loginUI());
  }

  Widget loginUI() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Icon(
          Icons.card_giftcard,
          size: 150.0,
          color: Theme.of(context).primaryColor,
        ),
        Column(
          children: <Widget>[
            Container(
              height: 50.0,
              constraints: BoxConstraints(maxWidth: 200.0),
              child: TextField(
                decoration: InputDecoration(hintText: 'Your Name'),
              ),
            ),
            Container(
              height: 50.0,
              constraints: BoxConstraints(maxWidth: 200.0),
              child: TextField(
                decoration: InputDecoration(hintText: 'Your PIN'),
              ),
            ),
            Container(
              constraints: BoxConstraints(maxWidth: 200.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: double.infinity),
                child: RaisedButton(
                  child: Text('Reveal Your Giftee'),
                  onPressed: () {
                    setState(() {
                      _startLoadingSanta = true;
                      _name = 'Mom';
                      _pin = '96867';
                    });
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

  FutureBuilder<Widget> Santa(String name, String pin) {
    return FutureBuilder<Widget>(
      future: _loadSanta(name, pin),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return snapshot.data;
        } else if (snapshot.hasError) {
          return Text('An error occurred.');
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
              style: TextStyle(fontSize: 24.0), textAlign: TextAlign.center,));
    } else if (response.statusCode == 200) {
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
              response.body,
              style: TextStyle(fontSize: 80.0),
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
