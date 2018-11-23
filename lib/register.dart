import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterFamilyScreenState extends State<RegisterFamilyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register a Group'),
      ),
    );
  }
}

class RegisterFamilyScreen extends StatefulWidget {
  @override
  RegisterFamilyScreenState createState() => new RegisterFamilyScreenState();
}
