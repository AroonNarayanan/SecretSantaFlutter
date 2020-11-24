import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:secret_santa/api.dart';
import 'package:secret_santa/card/family.dart';
import 'package:secret_santa/dialog/addmember.dart';
import 'package:secret_santa/screen/family.dart';

import './main.dart' as main;
import './resources.dart';
import 'models.dart';

class RegisterFamilyScreenState extends State<RegisterFamilyScreen> {
  List<FamilyMember> groupList = new List<FamilyMember>();
  final budgetController = TextEditingController();
  final newMemberNameController = TextEditingController();
  final newMemberInterestsController = TextEditingController();
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
                return addMemberDialog(
                    newMemberNameController, newMemberInterestsController, () {
                  if (newMemberNameController.text.trim() != "") {
                    groupList.add(FamilyMember(
                        newMemberNameController.text.trim(),
                        newMemberInterestsController.text.trim()));
                    newMemberNameController.clear();
                    newMemberInterestsController.clear();
                    setState(() {});
                    Navigator.of(context, rootNavigator: true).pop();
                  }
                });
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
              budgetCard(budgetController),
              dueDateCard(dueDateString, () async {
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
              }),
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
                    return staticFamilyMemberCard(groupList[i], () {
                      groupList.remove(groupList.removeAt(i));
                      setState(() {});
                    });
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
    final response =
        await registerFamily(budgetController.text, dueDate, groupList);
    if (response.statusCode == 200) {
      final groupResponse = json.decode(response.body);
      return familyCreatedScreen(groupResponse['id'], () {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
          return main.HomeState().familyScreen(groupResponse['id']);
        }));
      });
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
