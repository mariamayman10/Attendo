class Course {
  Course({
    required this.id,
    required this.courseName,
    required this.instructor,
    required this.students,
  });
  final String id;
  final String courseName;
  String instructor;
  final List<String> students;

  Map<String, dynamic> toMap() {
    return {
      'courseName': courseName,
      'id': id,
      'instructor': instructor,
      'students': students,
    };
  }

  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
      courseName: map['courseName'],
      id: map['id'],
      instructor: map['instructor'] != '' ? map['instructor'] : '',
      students:
          map['students'] != null ? List<String>.from(map['students']) : [],
    );
  }
}
