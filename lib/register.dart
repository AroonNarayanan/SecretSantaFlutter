import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import './main.dart' as main;

class RegisterFamilyScreenState extends State<RegisterFamilyScreen> {
  var groupList = <String>[];
  final budgetController = TextEditingController();
  final nameController = TextEditingController();
  var groupSubmitted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register a Group'),
        actions: <Widget>[
          Builder(builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                if (budgetController.text == '') {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text('Oops - your group needs a budget!'),
                  ));
                } else if (groupList.length == 0) {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text('Oops - your group needs members!'),
                  ));
                } else {
                  groupSubmitted = true;
                  setState(() {});
                }
              },
            );
          }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  child: Container(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          "Member Information",
                          style: TextStyle(fontSize: 16.0),
                        ),
                        TextField(
                          decoration: InputDecoration(labelText: "Name"),
                          controller: nameController,
                          textCapitalization: TextCapitalization.words,
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10.0),
                          width: double.infinity,
                          child: RaisedButton(
                            child: Text("Add Member"),
                            onPressed: () {
                              if (nameController.text.trim() != "") {
                                groupList.add(nameController.text.trim());
                                nameController.clear();
                                setState(() {});
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                );
              });
        },
        child: Icon(Icons.add),
      ),
      body: groupSubmitted ? creatingGroup() : createGroup(),
    );
  }

  Widget createGroup() {
    return Builder(builder: (BuildContext context) {
      return Container(
          padding: EdgeInsets.only(top: 20.0),
          width: double.infinity,
          child: Column(
            children: <Widget>[
              Text(
                'Set your budget:',
                style: TextStyle(fontSize: 20.0),
              ),
              Container(
                constraints: BoxConstraints(maxWidth: 100.0),
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(icon: Icon(Icons.attach_money)),
                  controller: budgetController,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20.0),
                child: Text(
                  'Members:',
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
              new Expanded(
                child: ListView.builder(
                  itemBuilder: (context, i) {
                    if (i.isOdd) {
                      return Divider();
                    }
                    return ListTile(
                      title: Text(groupList[i ~/ 2]),
                      onLongPress: () {
                        groupList.removeAt(i ~/ 2);
                        setState(() {});
                      },
                    );
                  },
                  itemCount: groupList.length * 2,
                ),
              )
            ],
          ));
    });
  }

  FutureBuilder<Widget> creatingGroup() {
    return FutureBuilder<Widget>(
      future: _registerFamily(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return snapshot.data;
        } else if (snapshot.hasError) {
          return Text(
            'An error occured: \n' + snapshot.error.toString(),
            textAlign: TextAlign.center,
          );
        }
        return Container(
          child: CupertinoActivityIndicator(),
          constraints: BoxConstraints(
              minWidth: double.infinity, minHeight: double.infinity),
        );
      },
    );
  }

  Future<Widget> _registerFamily() async {
    final groupJson =
        json.encode(Group('\$' + budgetController.text, groupList));
    final response = await http.post(
        'https://aroonsecretsanta.azurewebsites.net/registerFamily/',
        body: groupJson,
        encoding: Encoding.getByName("application/json"), headers: {
          'Content-Type': 'application/json'
    });
    if (response.statusCode == 200) {
      final groupResponse = json.decode(response.body);
      return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                child: Text('your group has been created!\nyour group ID is',
                    style: TextStyle(fontSize: 20.0), textAlign: TextAlign.center,),
                width: double.infinity,
                alignment: Alignment(0.0, 0.0)),
            Text(
              groupResponse['id'],
              style: TextStyle(fontSize: 30.0),
            ),
            Text(
              'make sure you write this down -\nyou won\'t see it again.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20.0),
            ),
            Container(
              margin: EdgeInsets.only(top: 10.0),
              child: RaisedButton(
                  child: Text('View Group'),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (BuildContext context) {
                      return main.HomeState.familyScreen(groupResponse['id']);
                    }));
                  }),
            )
          ]);
    } else {
      return Text('Error encountered. Please try again. \n' + response.statusCode.toString());
    }
  }
}

class RegisterFamilyScreen extends StatefulWidget {
  @override
  RegisterFamilyScreenState createState() => new RegisterFamilyScreenState();
}

class Group {
  String budget;
  List<String> family;

  Group(this.budget, this.family);

  Map<String, dynamic> toJson() =>
      {
        'budget': budget,
        'family': family,
      };
}
