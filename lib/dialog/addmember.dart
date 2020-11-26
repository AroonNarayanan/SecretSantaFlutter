import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Widget addMemberDialog(TextEditingController nameController, TextEditingController interestsController, Function onAdd) {
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
          TextField(
            decoration: InputDecoration(labelText: "Interests or Gift Ideas"),
            controller: interestsController,
            textCapitalization: TextCapitalization.words,
          ),
          Container(
            margin: EdgeInsets.only(top: 10.0),
            width: double.infinity,
            child: RaisedButton(
              child: Text("Add Member"),
              onPressed: () {
                onAdd();
              },
            ),
          )
        ],
      ),
    ),
  );
}