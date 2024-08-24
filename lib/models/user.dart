class User {
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.courses,
    required this.role,
    required this.attendanceRecords,
  });

  final String id;
  final String name;
  final String email;
  final String password;
  final String role;
  final List<String> courses;
  final List<DateTime> attendanceRecords;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'courses': courses,
      'role': role,
      'attendanceRecords':
          attendanceRecords.map((date) => date.toIso8601String()).toList(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      role: map['role'],
      courses: map['courses'] != null
          ? List<String>.from(map['courses']) // Updated to handle List<String>
          : [],
      attendanceRecords: map['attendanceRecords'] != null
          ? List<DateTime>.from(
              map['attendanceRecords'].map((date) => DateTime.parse(date)))
          : [],
    );
  }
}
