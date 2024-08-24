import 'package:attendo/models/user.dart';
import 'package:attendo/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:uuid/uuid.dart';

Uuid uuid = const Uuid();

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    var firstName = '';
    var lastName = '';
    var email = '';
    var password = '';
    var role = "Student";
    final formKey = GlobalKey<FormState>();

    void saveUser() {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();
        final String userId = uuid.v4();
        final newUser = User(
          id: userId,
          name: '$firstName $lastName',
          email: email,
          password: password,
          courses: [],
          role: role,
          attendanceRecords: [],
        );

        Map<String, dynamic> user = newUser.toMap();
        addUser(userId, user);
        Navigator.pop(context);
      }
    }

    String? validateFName(String? value) {
      if (value == null || value.isEmpty) {
        return 'Please enter a name';
      }
      final nameRegExp = RegExp(r'^[a-zA-Z]+$');
      if (!nameRegExp.hasMatch(value)) {
        return 'Please enter only letters';
      }
      firstName = value;
      return null;
    }

    String? validateLName(String? value) {
      if (value == null || value.isEmpty) {
        return 'Please enter a name';
      }
      final nameRegExp = RegExp(r'^[a-zA-Z]+$');
      if (!nameRegExp.hasMatch(value)) {
        return 'Please enter only letters';
      }
      lastName = value;
      return null;
    }

    String? validateEmail(String? value) {
      if (value == null || value.isEmpty) {
        return 'Please enter an email';
      }
      if (!EmailValidator.validate(value)) {
        return 'Please enter a valid email';
      }
      email = value;
      return null;
    }

    String? validatePassword(String? value) {
      if (value == null || value.isEmpty) {
        return 'Please enter a password';
      }
      if (value.length < 8) {
        return 'Password must be at least 8 characters';
      }
      final passwordRegExp = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');
      if (!passwordRegExp.hasMatch(value)) {
        return 'Password must include both letters and numbers';
      }
      password = value;
      return null;
    }

    String? validateConfirmPassword(String? value) {
      if (value == null || value.isEmpty) {
        return 'Please confirm your password';
      }
      if (value != password) {
        return 'Passwords do not match';
      }
      return null;
    }

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: Image.asset(
          "assets/images/iconC.png",
          width: 175,
        ),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(right: 28, left: 28, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 70,
              ),
              Text(
                "Create an Account",
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(fontWeight: FontWeight.bold, letterSpacing: 1),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Sign Up to Dive In",
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(fontWeight: FontWeight.bold, fontSize: 23),
              ),
              const SizedBox(height: 40),
              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: TextFormField(
                              keyboardType: TextInputType.name,
                              decoration: const InputDecoration(
                                labelText: 'First Name',
                                labelStyle: TextStyle(
                                    color: Color.fromARGB(255, 44, 44, 44)),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFF5f4bce)),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                              ),
                              validator: validateFName),
                        ),
                        const SizedBox(
                          width: 25,
                        ),
                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.name,
                            decoration: const InputDecoration(
                              labelText: 'Last Name',
                              labelStyle: TextStyle(
                                  color: Color.fromARGB(255, 44, 44, 44)),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF5f4bce)),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                            ),
                            validator: validateLName,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 13,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        labelStyle:
                            TextStyle(color: Color.fromARGB(255, 44, 44, 44)),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF5f4bce)),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                      validator: validateEmail,
                    ),
                    const SizedBox(
                      height: 13,
                    ),
                    TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        labelStyle:
                            TextStyle(color: Color.fromARGB(255, 44, 44, 44)),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF5f4bce)),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                      validator: validatePassword,
                    ),
                    const SizedBox(
                      height: 13,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: TextFormField(
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'Confirm Password',
                              labelStyle: TextStyle(
                                  color: Color.fromARGB(255, 44, 44, 44)),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF5f4bce)),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                            ),
                            validator: validateConfirmPassword,
                          ),
                        ),
                        const SizedBox(
                          width: 25,
                        ),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.only(bottom: 8),
                            ),
                            dropdownColor: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            value: "Student",
                            style: Theme.of(context).textTheme.bodyLarge,
                            items: const [
                              DropdownMenuItem(
                                value: "Student",
                                child: Text("Student"),
                              ),
                              DropdownMenuItem(
                                value: "Instructor",
                                child: Text("Instructor"),
                              ),
                            ],
                            onChanged: (String? value) {
                              role = value!;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 35),
                    ElevatedButton(
                      onPressed: saveUser,
                      child: Text(
                        "Sign Up",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
