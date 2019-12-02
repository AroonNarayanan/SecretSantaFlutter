class Group {
  String budget;
  String date;
  List<String> family;

  Group(this.budget, this.date, this.family);

  Map<String, dynamic> toJson() => {
    'budget': budget,
    'date': date,
    'family': family,
  };
}