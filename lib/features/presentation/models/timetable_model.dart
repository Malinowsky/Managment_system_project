class StudentSchedule {
  final String studentId;
  final String studentName;
  final List<DaySchedule> daySchedules;

  StudentSchedule({
    required this.studentId,
    required this.studentName,
    required this.daySchedules,
  });

  Map<String, dynamic> toJson() {
    return {
      'studentId': studentId,
      'studentName': studentName,
      'daySchedules': daySchedules.map((daySchedule) => daySchedule.toJson()).toList(),
    };
  }

  factory StudentSchedule.fromJson(Map<String, dynamic> json) {
    return StudentSchedule(
      studentId: json['studentId'].toString(),
      studentName: json['studentName'].toString(),
      daySchedules: (json['daySchedules'] as List).map((dayScheduleJson) =>
          DaySchedule.fromJson(dayScheduleJson)).toList(),
    );
  }
}

class DaySchedule {
  final String dayOfWeek;
  final List<ProfessorClass> professorClasses;

  DaySchedule({
    required this.dayOfWeek,
    required this.professorClasses,
  });

  Map<String, dynamic> toJson() {
    return {
      'dayOfWeek': dayOfWeek,
      'professorClasses': professorClasses.map((professorClass) => professorClass.toJson()).toList(),
    };
  }

  factory DaySchedule.fromJson(Map<String, dynamic> json) {
    return DaySchedule(
      dayOfWeek: json['dayOfWeek'].toString(),
      professorClasses: (json['professorClasses'] as List).map((professorClassJson) =>
          ProfessorClass.fromJson(professorClassJson)).toList(),
    );
  }
}

class ProfessorClass {
  final String className;
  final String professorName;
  final String subject;

  ProfessorClass({
    required this.className,
    required this.professorName,
    required this.subject,
  });

  Map<String, dynamic> toJson() {
    return {
      'className': className,
      'professorName': professorName,
      'subject': subject,
    };
  }

  factory ProfessorClass.fromJson(Map<String, dynamic> json) {
    return ProfessorClass(
      className: json['className'].toString(),
      professorName: json['professorName'].toString(),
      subject: json['subject'].toString(),
    );
  }
}
