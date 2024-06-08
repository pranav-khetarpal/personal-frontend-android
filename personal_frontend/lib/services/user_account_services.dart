import 'dart:convert';
import 'package:personal_frontend/ip_address_and_routes.dart';
import 'package:http/http.dart' as http;
import 'package:personal_frontend/services/authorization_services.dart';

class UserAccountServices {
  // object to use AuthServices methods
  final AuthServices authServices = AuthServices();

  // Create a new user document
  Future<void> createUserDocument({
    required String name,
    required String email,
    required String username,
  }) async {
    try {
      // Retrieve the Firebase token of the current logged-in user
      String token = await authServices.getIdToken();

      String url = IPAddressAndRoutes.getRoute('createUser');

      // Create the user data to be sent in the request body
      var userData = {
        'name': name,
        'email': email,
        'username': username,
      };

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(userData),
      );

      // Check if the request was successful
      if (response.statusCode == 200) {
        print('User document created successfully');
      } else {
        // Handle unsuccessful request
        print('Failed to create user document: ${response.statusCode} ${response.reasonPhrase}');
        print('Response body: ${response.body}');
        throw Exception('Failed to create user document');
      }
    } catch (e) {
      // Handle any errors that occur during the request
      print('Error occurred while creating user document: $e');
      rethrow;
    }
  }

  // Method to delete all of a user's content, including their posts
  Future<void> deleteUser() async {
    try {
      // Retrieve the Firebase token of the current logged-in user
      String token = await authServices.getIdToken();

      String url = IPAddressAndRoutes.getRoute('deleteUser');

      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        }
      );

      // Check if the request was successful
      if (response.statusCode == 200) {
        print('User deleted successfully');
      } else {
        // Handle unsuccessful request
        print('Failed to delete user: ${response.statusCode} ${response.reasonPhrase}');
        print('Response body: ${response.body}');
        throw Exception('Failed to delete user');
      }
    } catch (e) {
      // Log the error
      print('Error deleting user: $e');
      // Handle the error gracefully, e.g., show an error message to the user
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Failed to delete user')),
      // );
      // You can also throw the error if it needs to be handled at a higher level
      // throw Exception('Failed to delete user: $e');
    }
  }
}
