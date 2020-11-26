import 'package:secret_santa/api.dart';

class Group {
  String budget;
  DateTime due;
  String familyId;
  List<FamilyMember> members;

  Group(this.budget, this.due, this.members);

  Map<String, dynamic> toJson() =>
      {'budget': budget, 'due': due.toIso8601String(), 'members': members};

  Group.fromJson(Map<String, dynamic> json)
      : budget = json['budget'],
        due = DateTime.tryParse(json['due']),
        familyId = json['familyId'],
        members = parseFamilyMemberList(json['members']);
}

class FamilyMember {
  String name;
  String interests;
  String pin;
  Group family;
  FamilyMember giftee;
  bool legacy;

  FamilyMember(this.name, this.interests);

  FamilyMember.withPin(this.name, this.interests, this.pin);

  Map toJson() => {'name': name, 'interests': interests};

  FamilyMember.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        interests = json['interests'],
        pin = json['pin'],
        family = Group(json['family']['budget'],
            DateTime.tryParse(json['family']['due'] ?? ''), []),
        legacy = json['legacy'] ?? false,
        giftee =
            FamilyMember(json['giftee']['name'], json['giftee']['interests']);

  FamilyMember.fromJsonShallow(Map<String, dynamic> json)
      : name = json['name'],
        interests = json['interests'],
        pin = json['pin'];

  @override
  String toString() {
    return name;
  }
}
