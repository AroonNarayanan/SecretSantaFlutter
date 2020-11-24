class Group {
  String budget;
  String date;
  List<FamilyMember> family;

  Group(this.budget, this.date, this.family);

  Map<String, dynamic> toJson() => {
    'budget': budget,
    'date': date,
    'family': family,
  };
}

class FamilyMember {
  String name;
  String interests;

  FamilyMember(this.name, this.interests);

  Map toJson() => {
    'name': name,
    'interests': interests
  };

  @override
  String toString() {
    return name;
  }
}