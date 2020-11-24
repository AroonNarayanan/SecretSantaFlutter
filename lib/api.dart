import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'models.dart';
import 'resources.dart';

Future<Response> registerFamily(
    String budget, DateTime due, List<FamilyMember> family) async {
  final groupJson =
      json.encode(Group('\$' + budget, due.toIso8601String(), family));
  return await http.post(Config.registerFamily,
      body: groupJson,
      encoding: Encoding.getByName("application/json"),
      headers: {'Content-Type': 'application/json'});
}
