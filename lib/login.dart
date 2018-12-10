import 'dart:async';
import 'dart:convert';

import './resources.dart';
import './register.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
    return Container(
      color: Colors.grey[100],
      alignment: AlignmentDirectional.center,
      child: Card(
        elevation: 2.0,
        child: SingleChildScrollView(child: Container(
          padding: EdgeInsets.all(20.0),
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              child: new Icon(
                Icons.card_giftcard,
                size: 100.0,
                color: Theme.of(context).primaryColor,
              ),
            ),
            Container(
              width: 200.0,
              child: TextField(
                decoration: InputDecoration(hintText: 'Your Name'),
                controller: nameController,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 5.0),
              width: 200.0,
              child: TextField(
                decoration: InputDecoration(hintText: 'Your PIN'),
                controller: pinController,
                obscureText: true,
                keyboardType: TextInputType.number,
              ),
            ),
            Container(
              width: 200.0,
              margin: EdgeInsets.only(top: 5.0),
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
            Container(
              width: 200.0,
              child: FlatButton(
                child: Text('Don\'t have a PIN?'),
                onPressed: () {
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (BuildContext newPageContext) {
                    return RegisterFamilyScreen();
                  }));
                },
              ),
            )
          ],
        )),
      ),),
    );
  }

  void _login() {
    Navigator.of(context)
        .push(new MaterialPageRoute(builder: (BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text(Strings.secretSanta),
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
