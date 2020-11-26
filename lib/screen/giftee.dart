import 'package:flutter/material.dart';
import 'package:secret_santa/models.dart';
import 'package:secret_santa/resources.dart';

Widget gifteeScreen(FamilyMember familyMember) {
  return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
            child: Text(Strings.gifteeScreenHeader,
                style: TextStyle(fontSize: 24.0)),
            width: double.infinity,
            alignment: Alignment(0.0, 0.0)),
        Text(
          familyMember.giftee.name,
          style: TextStyle(fontSize: 80.0),
          textAlign: TextAlign.center,
        ),
        interestsHeader(familyMember),
        interestsText(familyMember),
        Container(
          child: Text(
            'your budget is ' + familyMember.family.budget,
            style: TextStyle(fontSize: 24.0),
          ),
          margin: EdgeInsets.only(top: 20),
        ),
        dueHeader(familyMember),
        dueText(familyMember),
        Container(
          child: Text(
            Strings.haveFun,
            style: TextStyle(fontSize: 20.0),
          ),
          margin: EdgeInsets.only(top: 20),
        )
      ]);
}

Widget interestsHeader(FamilyMember familyMember) {
  return familyMember.legacy
      ? Container()
      : Text(Strings.interestsHeader, style: TextStyle(fontSize: 20.0));
}

Widget interestsText(FamilyMember familyMember) {
  return familyMember.legacy
      ? Container()
      : Text(
          familyMember.giftee.interests,
          style: TextStyle(fontSize: 23.0),
          textAlign: TextAlign.center,
        );
}

Widget dueHeader(FamilyMember familyMember) {
  return familyMember.legacy
      ? Container()
      : Container(
          child: Text(
            Strings.dueHeader,
            style: TextStyle(fontSize: 20.0),
            textAlign: TextAlign.center,
          ),
          margin: EdgeInsets.only(top: 10),
        );
}

Widget dueText(FamilyMember familyMember) {
  return familyMember.legacy
      ? Container()
      : Text(
          Utils.dateToReadableString(familyMember.family.due),
          style: TextStyle(fontSize: 22.0),
          textAlign: TextAlign.center,
        );
}

Widget groupLoginScreen(BuildContext context,
    TextEditingController passphraseController, Function onView) {
  return Container(
    color: Colors.grey[100],
    alignment: AlignmentDirectional.center,
    child: Card(
      elevation: 2.0,
      child: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              child: new Icon(
                Icons.people,
                size: 100.0,
                color: Theme.of(context).primaryColor,
              ),
            ),
            Container(
              width: 200.0,
              child: TextField(
                decoration: InputDecoration(hintText: 'Group ID'),
                controller: passphraseController,
                keyboardType: TextInputType.number,
              ),
            ),
            Container(
              width: 200.0,
              margin: EdgeInsets.only(top: 5.0),
              child: Builder(builder: (BuildContext context) {
                return RaisedButton(
                  child: Text('View Group'),
                  onPressed: () {
                    onView();
                  },
                );
              }),
            )
          ],
        ),
      ),
    ),
  );
}
