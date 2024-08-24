import 'package:attendo/models/course.dart';
import 'package:attendo/models/user.dart';
import 'package:attendo/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CourseProvider extends ChangeNotifier {
  Future<List<Course>> getAllCourses() async {
    try {
      List<Course> result = [];
      final url = Uri.https(
          'attendo-d6197-default-rtdb.firebaseio.com', 'courses.json');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> courses = json.decode(response.body);
        for (var id in courses.keys) {
          final course = courses[id];
          result.add(Course.fromMap(course));
        }
        return result;
      } else {
        print('Failed to get courses');
        return [];
      }
    } catch (e) {
      print('An error occurred: $e');
      return [];
    }
  }

  Future<Course?> getCourse(String id) async {
    try {
      final url = Uri.https(
          'attendo-d6197-default-rtdb.firebaseio.com', 'courses/$id.json');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic>? courseMap = json.decode(response.body);

        if (courseMap != null) {
          return Course.fromMap(courseMap);
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

  Future<List<User>> getStudents(String courseId) async {
    Course? course = await getCourse(courseId);
    List<User> ret = [];
    UserProvider userProvider = UserProvider(CourseProvider());
    for (var student in course!.students) {
      User? user = await userProvider.getUser(student);
      ret.add(user!);
    }
    return ret;
  }
}
