import 'dart:convert';
import 'package:attendo/models/course.dart';
import 'package:attendo/models/user.dart';
import 'package:http/http.dart' as http;

const String firebaseProjectUrl = 'attendo-d6197-default-rtdb.firebaseio.com';

// Function to add a user
Future<void> addUser(String userId, Map<String, dynamic> userData) async {
  final url = Uri.https(firebaseProjectUrl, "users/$userId.json");

  final response = await http.put(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: json.encode(userData),
  );

  if (response.statusCode >= 400) {
    throw Exception('Failed to add user');
  }
}

// Function to get a user by userId
Future<User> getUser(String userId) async {
  final url = Uri.https(firebaseProjectUrl, "users/$userId.json");
  final response = await http.get(url);

  if (response.statusCode >= 400) {
    throw Exception('Failed to fetch user');
  }

  return User.fromMap(json.decode(response.body));
}

// Function to update a user by userId
Future<void> updateUser(String userId, Map<String, dynamic> userData) async {
  final url = Uri.https(firebaseProjectUrl, "users/$userId.json");
  final response = await http.patch(
    url,
    headers: {'Content-Type': 'application/json'},
    body: json.encode(userData),
  );

  if (response.statusCode >= 400) {
    throw Exception('Failed to update user');
  }
}

// Function to delete a user by userId
Future<void> deleteUser(String userId) async {
  final url = Uri.https(firebaseProjectUrl, "users/$userId.json");
  final response = await http.delete(url);

  if (response.statusCode >= 400) {
    throw Exception('Failed to delete user');
  }
}

Future<void> updateCourse(Course course) async {
  final url = Uri.https(firebaseProjectUrl, "courses/${course.id}.json");
  final response = await http.patch(
    url,
    headers: {'Content-Type': 'application/json'},
    body: json.encode(course.toMap()),
  );

  if (response.statusCode >= 400) {
    throw Exception('Failed to update course');
  }
}
