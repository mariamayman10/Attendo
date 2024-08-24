import 'package:attendo/models/user.dart';
import 'package:attendo/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:attendo/screens/sign_up.dart';
import 'package:provider/provider.dart';
import 'package:attendo/providers/user_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    var enteredEmail = '';
    var enteredPassword = '';
    final formKey = GlobalKey<FormState>();

    String? validateEmail(String? email) {
      if (email == null || email.isEmpty) {
        return 'Please enter an email';
      }
      enteredEmail = email;
      return null;
    }

    String? validatePass(String? password) {
      if (password == null || password.isEmpty) {
        return 'Please enter your password';
      }
      enteredPassword = password;
      return null;
    }

    Future<bool> signInUser() async {
      try {
        final url = Uri.https(
            'attendo-d6197-default-rtdb.firebaseio.com', 'users.json');
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final Map<String, dynamic> users = json.decode(response.body);
          for (var id in users.keys) {
            final user = users[id];
            if (user['email'] == enteredEmail &&
                user['password'] == enteredPassword) {
              User signedUser = User.fromMap(user);
              Provider.of<UserProvider>(context, listen: false)
                  .setUser(signedUser);
              return true;
            }
          }
          return false;
        } else {
          print('Failed to get users');
          return false;
        }
      } catch (e) {
        print('An error occurred during sign-in: $e');
        return false;
      }
    }

    void buttonClicked() {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();
        signInUser().then((isSignedIn) {
          if (isSignedIn) {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (ctx) => MainScreen()));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Sign-in failed: Invalid email or password')),
            );
          }
        }).catchError((error) {
          print('Sign-in error: $error');
        });
      }
    }

    void openSignUpModal() {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (ctx) => const SignUp()));
    }

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Image.asset(
          "assets/images/iconC.png",
          width: 175,
        ),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.only(right: 28, left: 28, bottom: 20),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 150),
                  Text(
                    "Welcome to Attendo!",
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        fontWeight: FontWeight.bold, letterSpacing: 1),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Sign In to Continue",
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium!
                        .copyWith(fontWeight: FontWeight.bold, fontSize: 23),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    children: [
                      Text(
                        "New to Attendo?",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: openSignUpModal,
                        child: const Text(
                          'Create New Account',
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Color(0xFF5f4bce),
                              decoration: TextDecoration.underline),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
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
                      const SizedBox(height: 20),
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
                        validator: validatePass,
                      ),
                      const SizedBox(height: 35),
                      ElevatedButton(
                        onPressed: buttonClicked,
                        child: Text(
                          "Sign In",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
