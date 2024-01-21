class ClassGroup {
  String id;
  String name;
  List<String> studentIds;

  ClassGroup({
    required this.id,
    required this.name,
    this.studentIds = const [],
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'studentIds': studentIds,
  };

  static ClassGroup fromJson(Map<String, dynamic> json) => ClassGroup(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    studentIds: List<String>.from(json['studentIds'] ?? []),
  );
}
