import 'package:attendo/models/course.dart';
import 'package:attendo/widgets/course_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EnrollCourse extends StatefulWidget {
  const EnrollCourse({super.key});

  @override
  State<EnrollCourse> createState() => _EnrollCourseState();
}

class _EnrollCourseState extends State<EnrollCourse> {
  final TextEditingController _searchController = TextEditingController();
  List<Course> result = [];
  Widget content = const Center(
    child: Text(
      "Search by course id to enroll!",
      style: TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 131, 131, 131)),
    ),
  );

  Future<bool> getCourses() async {
    try {
      final url = Uri.https(
          'attendo-d6197-default-rtdb.firebaseio.com', 'courses.json');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> courses = json.decode(response.body);
        result = [];
        for (var id in courses.keys) {
          final course = courses[id];
          if (course['id'].contains(_searchController.text)) {
            result.add(Course.fromMap(course));
          }
        }
        return true;
      } else {
        print('Failed to get courses');
        return false;
      }
    } catch (e) {
      print('An error occurred during fetching courses: $e');
      return false;
    }
  }

  void displayCourses() async {
    bool fetchSuccess = await getCourses();
    if (fetchSuccess) {
      setState(() {
        if (result.isEmpty) {
          content = const Center(
            child: Text(
              "No courses found",
              style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 131, 131, 131)),
            ),
          );
        } else {
          content = Expanded(
            child: SizedBox(
              height: double.infinity,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: result.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    child: CourseWidget(courseCode: result[index].id),
                  );
                },
              ),
            ),
          );
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Searching failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10, left: 10, top: 20),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search...',
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () => _searchController.clear(),
              ),
              prefixIcon: IconButton(
                icon: const Icon(Icons.search),
                onPressed: displayCourses,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          content
        ],
      ),
    );
  }
}
