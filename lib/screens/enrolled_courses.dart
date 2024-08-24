import 'package:attendo/models/course.dart';
import 'package:attendo/widgets/course_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:attendo/providers/user_provider.dart';

class EnrolledCourses extends StatelessWidget {
  const EnrolledCourses({super.key});

  Future<List<Course>> getCourses() async {
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Course>>(
      future: getCourses(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No courses available'));
        } else {
          List<Course> allCourses = snapshot.data!;
          List<String> coursesCode =
              Provider.of<UserProvider>(context, listen: false).getCourses();
          List<Course> userCourses = allCourses
              .where((course) => coursesCode.contains(course.id))
              .toList();

          return SingleChildScrollView(
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: userCourses.isNotEmpty
                    ? Column(
                        children: userCourses.map((course) {
                          return CourseWidget(courseCode: course.id);
                        }).toList(),
                      )
                    : const Center(
                        child: Text(
                          "No Enrolled Courses",
                          style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 131, 131, 131)),
                        ),
                      )),
          );
        }
      },
    );
  }
}
