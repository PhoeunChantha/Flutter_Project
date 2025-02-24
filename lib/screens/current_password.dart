import 'package:flutter/material.dart';
import 'package:flutter_appd106d1/app_colors.dart';
import 'package:flutter_appd106d1/app_url.dart';
import 'package:flutter_appd106d1/screens/new_password.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrentPassword extends StatefulWidget {
  const CurrentPassword({super.key});

  @override
  State<CurrentPassword> createState() => _CurrentPasswordState();
}

class _CurrentPasswordState extends State<CurrentPassword> {
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  static const String apiUrl = "${AppUrl.url}current_password.php";

  Future<bool> checkCurrentPassword(String username, String currentPassword) async {
    var uri = Uri.parse(apiUrl);

    // Prepare the request
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': username,
        'current_password': currentPassword,
      }),
    );

    // Log the response for debugging
    print("Response Status: ${response.statusCode}");
    print("Response Body: ${response.body}");

    // Check the response status
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print("Decoded Response: $responseData"); // Log the decoded response

      // Check if the response indicates success
      return responseData['status'] == 'success';
    } else {
      // Handle error
      throw Exception('Failed to verify password');
    }
  }

  void _onContinuePressed() async {
    String currentPassword = _passwordController.text;

    if (currentPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your current password')),
      );
      return;
    }

    // Replace with the actual username you want to check
    String username = 'chantha'; // Obtain this from your app's state or context

    try {
      bool isPasswordValid = await checkCurrentPassword(username, currentPassword);

      if (isPasswordValid) {
        // If password is correct, navigate to the new password page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const NewPassword(),
          ),
        );
      } else {
        // Show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Incorrect password')),
        );
      }
    } catch (error) {
      // Log the error to debug
      print("Error: $error");
      // Handle network errors or other exceptions
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to verify password')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.teal,
        elevation: 0,
        title: const Text('Current Password'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon with a Question Mark
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.teal,
              ),
              child: const Center(
                child: Icon(
                  Icons.question_mark,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Current Password Input Field
            TextField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: _togglePasswordVisibility,
                ),
                hintText: 'Current Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Continue Button
            ElevatedButton(
              onPressed: _onContinuePressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.teal,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                'Continue',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}