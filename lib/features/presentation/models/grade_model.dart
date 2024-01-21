class Grade {
  final int id;
  final int studentId;
  final int courseId;
  final int professorId;
  final double grade;
  final String date;
  final String additionalComments;

  Grade({
    required this.id,
    required this.studentId,
    required this.courseId,
    required this.professorId,
    required this.grade,
    required this.date,
    this.additionalComments = '',
  });

  // Metoda do konwersji obiektu na mapę (użyteczna przy zapisie do bazy danych)
  Map<String, dynamic> toJson() => {
    'id': id,
    'studentId': studentId,
    'courseId': courseId,
    'professorId': professorId,
    'grade': grade,
    'date': date,
    'additionalComments': additionalComments,
  };

  // Metoda do tworzenia obiektu Grade z mapy (użyteczna przy odczycie z bazy danych)
  static Grade fromJson(Map<String, dynamic> json) => Grade(
    id: json['id'],
    studentId: json['studentId'],
    courseId: json['courseId'],
    professorId: json['professorId'],
    grade: json['grade'].toDouble(),
    date: json['date'],
    additionalComments: json['additionalComments'] ?? '',
  );
}
