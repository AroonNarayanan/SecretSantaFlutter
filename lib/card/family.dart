import 'package:flutter/material.dart';

import '../models.dart';
import '../resources.dart';

Card staticFamilyMemberCard(FamilyMember familyMember, Function onDelete) {
  return Card(
    elevation: 2.0,
    child: ListTile(
      title: Text(familyMember.name),
      subtitle: Text(familyMember.interests),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        tooltip: Strings.removeMember,
        onPressed: () {
          onDelete();
        },
      ),
    ),
  );
}

Card budgetCard(budgetController) {
  return Card(
    elevation: 2.0,
    child: Container(
      width: double.infinity,
      margin: EdgeInsets.all(10.0),
      child: Row(
        children: <Widget>[
          Text(
            Strings.budget,
            style: TextStyle(fontSize: 16.0),
          ),
          Spacer(),
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
  );
}

Card dueDateCard(String dueDateString, Function onPickDate) {
  return Card(
    elevation: 2.0,
    child: Container(
      margin: EdgeInsets.all(10.0),
      width: double.infinity,
      child: Column(
        children: <Widget>[
          RaisedButton(
            child: Text(Strings.dueDate),
            onPressed: () async {
              await onPickDate();
            },
          ),
          Text(dueDateString),
        ],
      ),
    ),
  );
}