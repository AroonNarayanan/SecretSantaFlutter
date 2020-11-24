import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Widget familyCreatedScreen(String familyId, Function onViewGroup) {
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
          familyId,
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
                onViewGroup();
              }),
        )
      ]);
}