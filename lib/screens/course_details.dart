import 'package:attendo/models/course.dart';
import 'package:attendo/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:attendo/models/user.dart';
import 'package:attendo/services/firebase_service.dart';

import 'dart:math';

import 'package:provider/provider.dart';

class CourseDetails extends StatefulWidget {
  const CourseDetails(
      {super.key, required this.course, required this.students});

  final Course course;
  final List<User> students;

  @override
  State<CourseDetails> createState() => _CourseDetailsState();
}

class _CourseDetailsState extends State<CourseDetails> {
  String instructorName = '';
  final images = [
    "assets/images/courseBG1.jpeg",
    "assets/images/courseBG2.jpeg",
    "assets/images/courseBG3.jpeg"
  ];
  Future<void> getInstructor() async {
    if (widget.course.instructor.isEmpty) {
      setState(() {
        instructorName = 'No instructor is set yet';
      });
    } else {
      User instructor = await getUser(widget.course.instructor);
      setState(() {
        instructorName = instructor.name;
      });
    }
  }

  void removeStudent(String id) async {
    setState(() {
      Provider.of<UserProvider>(context, listen: false)
          .removeCourse(id, widget.course.id);
    });
  }

  @override
  void initState() {
    super.initState();
    getInstructor();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Course Details",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                images[Random().nextInt(3)],
              ),
            ),
            const SizedBox(
              height: 18,
            ),
            Text(
              widget.course.courseName,
              style: const TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 12,
            ),
            Row(
              children: [
                const Text(
                  "Instructor:",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  width: 7,
                ),
                Text(
                  instructorName,
                  style: const TextStyle(
                      color: Color.fromARGB(255, 99, 99, 99), fontSize: 20),
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            widget.students.isEmpty
                ? const Text(
                    "No Students Enrolled",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )
                : const Text(
                    "Students",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
            Column(
              children: widget.students.map((student) {
                return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          student.name,
                          style: const TextStyle(fontSize: 17),
                        ),
                        IconButton(
                            onPressed: () {
                              removeStudent(student.id);
                            },
                            icon: const Icon(Icons.remove_circle))
                      ],
                    ));
              }).toList(),
            )
          ],
        ),
      ),
    );
  }
}
