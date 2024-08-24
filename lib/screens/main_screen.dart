import 'package:attendo/screens/dashboard.dart';
import 'package:attendo/screens/enroll_course.dart';
import 'package:attendo/screens/enrolled_courses.dart';
import 'package:attendo/screens/profile.dart';
import 'package:attendo/widgets/drawer.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Widget activeScreen = const Dashboard();
  var activeScreenTitle = "Dashboard";

  void _setScreen(String identifier) {
    setState(() {
      Navigator.of(context).pop();
      if (identifier == 'profile') {
        activeScreen = const Profile();
        activeScreenTitle = "Profile";
      } else if (identifier == 'dashboard') {
        activeScreen = const Dashboard();
        activeScreenTitle = "Dashboard";
      } else if (identifier == 'enrolled') {
        activeScreen = const EnrolledCourses();
        activeScreenTitle = "Enrolled Courses";
      } else if (identifier == 'enroll') {
        activeScreen = const EnrollCourse();
        activeScreenTitle = "Enroll Course";
      } else if (identifier == 'logout') {
        activeScreen = const Profile();
        activeScreenTitle = "Profile";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(37),
            bottomRight: Radius.circular(37),
          ),
          child: AppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            title: Text(
              activeScreenTitle,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: Image.asset(
                    "assets/images/menuIcon.png",
                    scale: 1,
                  ),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                );
              },
            ),
            centerTitle: true,
            elevation: 0,
          ),
        ),
      ),
      drawer: MainDrawer(
        setScreen: _setScreen,
      ),
      body: activeScreen,
    );
  }
}
