import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:attendo/screens/course_details.dart';
import 'package:attendo/models/course.dart';
import 'package:attendo/models/user.dart';
import 'package:attendo/providers/course_provider.dart';
import 'package:attendo/providers/user_provider.dart';
import 'package:attendo/services/firebase_service.dart';

class CourseWidget extends StatefulWidget {
  const CourseWidget({super.key, required this.courseCode});

  final String courseCode;

  @override
  State<CourseWidget> createState() => _CourseWidgetState();
}

class _CourseWidgetState extends State<CourseWidget> {
  Course? course;
  bool isLoading = true;
  bool hasError = false;
  List<User> students = [];
  String instructorName = '';
  Widget studentsRow = const Text("Loading students...");
  final List<Color> _colors = [
    const Color.fromARGB(255, 23, 21, 105),
    const Color.fromARGB(255, 68, 45, 1),
    const Color.fromARGB(255, 76, 76, 76),
  ];

  @override
  void initState() {
    super.initState();
    _fetchCourse();
  }

  Future<void> _fetchCourse() async {
    try {
      final courseProvider =
          Provider.of<CourseProvider>(context, listen: false);
      Course? fetchedCourse = await courseProvider.getCourse(widget.courseCode);

      if (fetchedCourse != null) {
        setState(() {
          course = fetchedCourse;
          isLoading = false;
        });
        await getStudents();
        if (course!.instructor.isNotEmpty) {
          await getInstructor();
        }
      } else {
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  Future<void> getInstructor() async {
    if (course!.instructor.isNotEmpty) {
      User instructor = await getUser(course!.instructor);
      setState(() {
        instructorName = instructor.name;
      });
    }
  }

  Future<void> getStudents() async {
    if (course == null || course!.students.isEmpty) {
      setState(() {
        studentsRow = const Text("No enrolled students");
      });
      return;
    }

    try {
      List<Widget> studentWidgets = [];
      for (int i = 0; i < course!.students.length; i++) {
        User user = await getUser(course!.students[i]);
        students.add(user);
        studentWidgets.add(Container(
          margin: const EdgeInsets.only(right: 5),
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: _colors[Random().nextInt(_colors.length)],
          ),
          child: Center(
            child: Text(
              getShortenName(user.name),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ));
      }

      if (course!.students.length > 3) {
        studentWidgets.add(Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromARGB(255, 185, 185, 185)),
          child: Center(
            child: Text(
              "+ ${course!.students.length - 3}",
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ));
      }

      setState(() {
        studentsRow = Row(children: studentWidgets);
      });
    } catch (e) {
      setState(() {
        studentsRow = const Text("Error loading students");
      });
    }
  }

  String getShortenName(String s) {
    String res = s.isNotEmpty ? s[0] : '';
    for (var i = 0; i < s.length - 1; i++) {
      if (s[i] == ' ') {
        res += s[i + 1];
      }
    }
    return res;
  }

  void openCourseDetails() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => CourseDetails(
              course: course!,
              students: students,
            )));
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (hasError) {
      return const Center(child: Text('Failed to load course'));
    }
    if (course == null) {
      return const Center(child: Text('No course data available'));
    }

    return InkWell(
      onTap: () {
        openCourseDetails();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 25),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: const Color.fromARGB(237, 236, 236, 236),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 3,
              blurRadius: 10,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        width: double.infinity,
        child: Padding(
          padding:
              const EdgeInsets.only(right: 20, left: 20, top: 20, bottom: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                course!.courseName,
                style: const TextStyle(
                    color: Color(0xFF5f4bce),
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
              const SizedBox(
                height: 7,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Code: ${widget.courseCode}"),
                  Text(
                      "Instructor: ${instructorName == '' ? 'Not set yet' : instructorName}"),
                ],
              ),
              const SizedBox(
                height: 9,
              ),
              studentsRow,
              const SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const SizedBox(),
                ElevatedButton(
                    onPressed: Provider.of<UserProvider>(context, listen: false)
                            .courseExist(widget.courseCode)
                        ? null
                        : () {
                            setState(() {
                              Provider.of<UserProvider>(context, listen: false)
                                          .getRole() ==
                                      'Student'
                                  ? Provider.of<UserProvider>(context,
                                          listen: false)
                                      .addCourse(widget.courseCode)
                                  : Provider.of<UserProvider>(context,
                                          listen: false)
                                      .teachCourse(widget.courseCode);
                            });
                          },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.only(left: 15, right: 22),
                    ),
                    child: Provider.of<UserProvider>(context, listen: false)
                            .courseExist(widget.courseCode)
                        ? const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.check),
                              SizedBox(width: 10),
                              Text("Enrolled"),
                            ],
                          )
                        : const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.add),
                              SizedBox(width: 10),
                              Text("Enroll"),
                            ],
                          )),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
