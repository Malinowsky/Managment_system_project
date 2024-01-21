class Course {
  final String id; // Unikalny identyfikator kursu
  final String name; // Nazwa kursu
  final String description; // Opis kursu
  final int credits; // Liczba punktów ECTS lub inna miara
  final String professorId; // Identyfikator wykładowcy prowadzącego kurs
  List<String> reserveStudentsId;
  List<String> groupStudentIds;

  Course({
    required this.id,
    required this.name,
    required this.description,
    required this.credits,
    required this.professorId,
    this.reserveStudentsId = const [],
    this.groupStudentIds = const [],
  });

  Course.empty()
      : id = '',
        name = '',
        description = '',
        credits = 0,
        professorId = '',
        reserveStudentsId = [],
        groupStudentIds = [];


  // Konwersja z formatu JSON (użyteczna przy odczycie z bazy danych)
  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      credits: json['credits'],
      professorId: json['professorId'],
      reserveStudentsId: List<String>.from(json['reserveStudentsId'] ?? []),
      groupStudentIds: List<String>.from(json['groupStudentIds'] ?? []),
    );
  }

  // Konwersja do formatu JSON (użyteczna przy zapisie do bazy danych)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'credits': credits,
      'professorId': professorId,
      'reserveStudentsId': reserveStudentsId,
      'groupStudentIds': groupStudentIds,
    };
  }
}
