import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'models.dart';
import 'resources.dart';

Future<Response> registerFamily(
    String budget, DateTime due, List<FamilyMember> family) async {
  final groupJson = json.encode(Group('\$' + budget, due, family));
  return await http.post(Config.registerFamily,
      body: groupJson,
      encoding: Encoding.getByName("application/json"),
      headers: {'Content-Type': 'application/json'});
}

Future<Response> loadFamily(String passphrase) async {
  return await http.get(Config.loadFamily + passphrase);
}

Future<Response> loadMember(String name, String pin) async {
  return await http.get(Config.loadMember + name + '?pin=' + pin);
}

List<FamilyMember> parseFamilyMemberList(dynamic jsonFamilyMembers) {
  if (jsonFamilyMembers != null) {
    var jsonFamilyMembersList = jsonFamilyMembers as List;
    return jsonFamilyMembersList.map((e) => FamilyMember.fromJsonShallow(e)).toList();
  }
  return [];
}
