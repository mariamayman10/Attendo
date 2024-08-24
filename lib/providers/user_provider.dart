import 'package:attendo/models/course.dart';
import 'package:attendo/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:attendo/models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:attendo/providers/course_provider.dart';

class UserProvider extends ChangeNotifier {
  late User _user;
  final CourseProvider courseProvider;

  UserProvider(this.courseProvider);

  User get user => _user;
  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  Future<User?> getUser(String id) async {
    try {
      final url = Uri.https(
          'attendo-d6197-default-rtdb.firebaseio.com', 'users/$id.json');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic>? userMap = json.decode(response.body);

        if (userMap != null) {
          return User.fromMap(userMap);
        } else {
          print('Course data is null');
          return null;
        }
      } else {
        print('Failed to get course. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('An error occurred: $e');
      return null;
    }
  }

  void addCourse(String courseCode) {
    _user.courses.add(courseCode);
    updateUser(user.id, _user.toMap());

    courseProvider.getAllCourses().then((retList) {
      if (retList.isEmpty) {
        print("No courses available");
      } else {
        for (var item in retList) {
          if (item.id == courseCode) {
            item.students.add(_user.id);
            updateCourse(item);
            break;
          }
        }
      }
    });
  }

  void removeCourse(String studentId, String courseId) async {
    User? user = await getUser(studentId);
    user!.courses.removeWhere((c) => c == courseId);
    updateUser(studentId, user.toMap());
    CourseProvider courseProvider = CourseProvider();
    Course? course = await courseProvider.getCourse(courseId);
    course!.students.removeWhere((student) => student == studentId);
    updateCourse(course);
  }

  void teachCourse(String courseCode) {
    _user.courses.add(courseCode);
    updateUser(user.id, _user.toMap());

    courseProvider.getAllCourses().then((retList) {
      if (retList.isEmpty) {
        print("No courses available");
      } else {
        for (var item in retList) {
          if (item.id == courseCode) {
            item.instructor = _user.id;
            updateCourse(item);
            break;
          }
        }
      }
    });
  }

  bool courseExist(String courseCode) {
    return _user.courses.contains(courseCode);
  }

  List<String> getCourses() {
    return _user.courses;
  }

  void addAttendance(DateTime date) {
    _user.attendanceRecords.add(date);
    updateUser(user.id, _user.toMap());
  }

  void removeAttendace(DateTime date) {
    _user.attendanceRecords.removeWhere((d) =>
        d.year == date.year && d.month == date.month && d.day == date.day);
    updateUser(user.id, _user.toMap());
  }

  bool attendanceExist(DateTime date) {
    return _user.attendanceRecords.any((d) =>
        d.year == date.year && d.month == date.month && d.day == date.day);
  }

  List<DateTime> getAttendaceRecords() {
    return _user.attendanceRecords;
  }

  String getName() {
    return _user.name;
  }

  String getRole() {
    return _user.role;
  }
}
