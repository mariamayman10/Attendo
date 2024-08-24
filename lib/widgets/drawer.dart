import 'package:attendo/providers/user_provider.dart';
import 'package:attendo/screens/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key, required this.setScreen});

  final void Function(String identifier) setScreen;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF5f4bce),
      width: double.infinity,
      child: Stack(
        children: [
          Positioned(
            bottom: 20,
            right: 20,
            child: Image.asset(
              'assets/images/drawer.png',
              width: 300,
              height: 300,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 110),
            child: Column(
              children: [
                ListTile(
                  leading: ClipOval(
                    child: Image.asset(
                      "assets/images/profile.jpeg",
                    ),
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Provider.of<UserProvider>(context).getName(),
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontWeight: FontWeight.bold),
                      ),
                      Text(
                        Provider.of<UserProvider>(context).getRole(),
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                // Dashboard
                ListTile(
                  title: Text(
                    'Dashboard',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 24,
                        ),
                  ),
                  onTap: () {
                    setScreen('dashboard');
                  },
                ),
                // Enrolled Courses
                ListTile(
                  title: Text(
                    'Enrolled Courses',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 24,
                        ),
                  ),
                  onTap: () {
                    setScreen('enrolled');
                  },
                ),
                // Enroll Course
                ListTile(
                  title: Text(
                    'Enroll Course',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 24,
                        ),
                  ),
                  onTap: () {
                    setScreen('enroll');
                  },
                ),
                // Log out
                ListTile(
                  title: Text(
                    'Log out',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 24,
                        ),
                  ),
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (ctx) => const SignIn()));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
