import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegisterFamilyScreenState extends State<RegisterFamilyScreen> {
  var groupList = <String>[];
  final budgetController = TextEditingController();
  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register a Group'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {},
          )
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
      body: Container(
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
          )),
    );
  }
}

class RegisterFamilyScreen extends StatefulWidget {
  @override
  RegisterFamilyScreenState createState() => new RegisterFamilyScreenState();
}
