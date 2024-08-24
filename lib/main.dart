import 'package:attendo/providers/course_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:attendo/screens/sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:attendo/providers/user_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final courseProvider = CourseProvider();
  final userProvider = UserProvider(courseProvider);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<CourseProvider>(create: (_) => courseProvider),
        ChangeNotifierProvider<UserProvider>(create: (_) => userProvider),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return (MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: const ColorScheme(
            brightness: Brightness.light,
            primary: Color.fromARGB(255, 83, 66, 180),
            onPrimary: Color.fromARGB(255, 200, 200, 200),
            secondary: Color(0xFF5f4bce),
            onSecondary: Color.fromARGB(255, 50, 50, 50),
            surface: Color.fromARGB(246, 34, 34, 34),
            onSurface: Color(0xDD222222),
            error: Colors.red,
            onError: Colors.white,
          ),
          scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
          cardColor: Colors.white,
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context)
              .textTheme
              .copyWith(
                  headlineLarge: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 24),
                  bodyLarge: const TextStyle(fontSize: 16),
                  bodyMedium: const TextStyle(fontSize: 14),
                  bodySmall: const TextStyle(fontSize: 12))),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5f4bce),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          iconTheme: const IconThemeData(
            color: Color(0xFF5f4bce),
          ),
          dropdownMenuTheme: const DropdownMenuThemeData(
            textStyle: TextStyle(color: Color.fromARGB(255, 49, 49, 49)),
          ),
          datePickerTheme: DatePickerThemeData(
              backgroundColor: Theme.of(context).colorScheme.onSecondary),
          dividerColor: Colors.grey[300],
          snackBarTheme: SnackBarThemeData(
              backgroundColor: Colors.black45,
              contentTextStyle: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Colors.white))),
      home: const SignIn(),
    ));
  }
}
