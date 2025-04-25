// This is a Band model class

class Band {
  String id;
  String name;
  int votes;

  Band({required this.id, required this.name, required this.votes});

  // factory constructor returns instance of Band class
  factory Band.fromMap(Map<String, dynamic> obj) =>
      Band(id: obj['id'], name: obj['name'], votes: obj['votes']);
}
