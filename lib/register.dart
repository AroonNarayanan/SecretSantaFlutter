import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import './main.dart' as main;
import './resources.dart';

class RegisterFamilyScreenState extends State<RegisterFamilyScreen> {
  var groupList = <String>[];
  final budgetController = TextEditingController();
  final nameController = TextEditingController();
  var groupSubmitted = false;
  DateTime dueDate;
  var dueDateString = 'no date set';

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
                } else if (dueDate == null) {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content:
                        Text('Oops - your group needs gift exchange date!'),
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
          padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
          color: Colors.grey[100],
          width: double.infinity,
          child: Column(
            children: <Widget>[
              Card(
                elevation: 2.0,
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.all(10.0),
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
                          decoration:
                              InputDecoration(icon: Icon(Icons.attach_money)),
                          controller: budgetController,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                elevation: 2.0,
                child: Container(
                  margin: EdgeInsets.all(10.0),
                  width: double.infinity,
                  child: Column(
                    children: <Widget>[
                      RaisedButton(
                        child: Text('Set Gift Exchange Date'),
                        onPressed: () async {
                          dueDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime(DateTime.now().year,
                                DateTime.now().month, DateTime.now().day + 14),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          dueDateString = dueDate != null
                              ? Utils.dateToReadableString(dueDate)
                              : 'no date set';
                          setState(() {});
                        },
                      ),
                      Text(dueDateString),
                    ],
                  ),
                ),
              ),
              Card(
                elevation: 3.0,
                child: Column(
                  children: <Widget>[],
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
                    return Card(
                      elevation: 2.0,
                      child: ListTile(
                        title: Text(groupList[i]),
                        onLongPress: () {
                          groupList.removeAt(i);
                          setState(() {});
                        },
                      ),
                    );
                  },
                  itemCount: groupList.length,
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
        json.encode(Group('\$' + budgetController.text, dueDate.toIso8601String(), groupList));
    final response = await http.post(
        'https://aroonsecretsanta.azurewebsites.net/registerFamily/',
        body: groupJson,
        encoding: Encoding.getByName("application/json"),
        headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      final groupResponse = json.decode(response.body);
      return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                child: Text(
                  'your group has been created!\nyour group ID is',
                  style: TextStyle(fontSize: 20.0),
                  textAlign: TextAlign.center,
                ),
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
      return Text('Error encountered. Please try again. \n' +
          response.statusCode.toString());
    }
  }
}

class RegisterFamilyScreen extends StatefulWidget {
  @override
  RegisterFamilyScreenState createState() => new RegisterFamilyScreenState();
}

class Group {
  String budget;
  String date;
  List<String> family;

  Group(this.budget, this.date, this.family);

  Map<String, dynamic> toJson() => {
        'budget': budget,
        'date': date,
        'family': family,
      };
}
