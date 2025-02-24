import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_appd106d1/app_colors.dart';
import 'package:flutter_appd106d1/app_url.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UserProfile extends StatefulWidget {
  final Function() onProfileUpdated;
  const UserProfile({super.key, required this.onProfileUpdated});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  String? _fullname;
  String? _username;
  String? _phone;
  String? _email;
  String _image = 'default.jpg';
  late int _id;

  File? _newImage;
  final imgPicker = ImagePicker();

  final _fullnameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  @override
  void dispose() {
    _fullnameController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> loadUserData() async {
    final sp = await SharedPreferences.getInstance();
    setState(() {
      _id = sp.getInt("USER_ID") ?? 0;
      _fullname = sp.getString("USER_FULLNAME");
      _username = sp.getString("USER_NAME");
      _phone = sp.getString("USER_PHONE");
      _email = sp.getString("USER_EMAIL");
      _image = sp.getString("USER_IMAGE")!;
      _fullnameController.text = _fullname!;
      _usernameController.text = _username!;
      _phoneController.text = _phone!;
      _emailController.text = _email!;
    });
  }

  Future<void> _changeImage() async {
    final pickedFile = await imgPicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _newImage = File(pickedFile.path);
        _image = pickedFile.path;
      });
    } else {
      print("No image selected.");
    }
  }

  Future<void> _save() async {
    if (_fullnameController.text.isEmpty ||
        _usernameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Please fill all the fields."),
        ),
      );
      return;
    }

    EasyLoading.show(status: 'Saving...');

    Map<String, String> data = {
      "UserID": _id.toString(),
      "UserName": _usernameController.text,
      "FullName": _fullnameController.text,
      "PhoneNumber": _phoneController.text,
      "UserEmail": _emailController.text,
    };

    if (_newImage != null) {
      final bytes = await _newImage!.readAsBytes();
      String base64Image = base64Encode(bytes);
      data["NewImageProfile"] = base64Image;
    }

    try {
      final response = await http.post(
        Uri.parse('${AppUrl.url}edit_profile.php'),
        body: data,
      );

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        print('CHECK RESULT: $result');

        if (result['success'] == 1) {
          EasyLoading.showSuccess(result["msg_success"]);

          final sp = await SharedPreferences.getInstance();

          Map<String, dynamic> updatedUser = result["UpdatedUser"];
          sp.setString("USER_NAME", updatedUser["UserName"]);
          sp.setString("USER_FULLNAME", updatedUser["FullName"]);
          sp.setString("USER_PHONE", updatedUser["PhoneNumber"]);
          sp.setString("USER_EMAIL", updatedUser["UserEmail"]);

          if (updatedUser["UserImage"] != null) {
            sp.setString("USER_IMAGE", updatedUser["UserImage"]);
            setState(() {
              _image = updatedUser["UserImage"];
            });
          }

          widget.onProfileUpdated();
          Navigator.pop(context);
        } else {
          EasyLoading.showError(result["msg_error"]);
        }
      } else {
        EasyLoading.showError('Failed to update profile.');
      }
    } catch (e) {
      EasyLoading.showError('An error occurred. Please try again.');
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(
            height: 200,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 50),
                  decoration: const BoxDecoration(
                    color: AppColors.mainColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: 150,
                    height: 150,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        _newImage != null
                            ? Container(
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: FileImage(_newImage!),
                                  ),
                                ),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 46, 63, 79),
                                  shape: BoxShape.circle,
                                ),
                                child: ClipOval(
                                  child: Image.network(
                                    '${AppUrl.url}images/$_image',
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) => Center(
                                      child: Icon(
                                        Icons.person, // Icon to show on error
                                        size: 80,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.black87,
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () async {
                                  print("Image picker tapped");
                                  await _changeImage();
                                },
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildTextInput('Username', _usernameController),
                    _buildTextInput('Full Name', _fullnameController),
                    _buildTextInput('Phone Number', _phoneController),
                    _buildTextInput('Email', _emailController),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                padding: const EdgeInsets.all(15),
                width: double.infinity,
                color: Colors.white,
                child: InkWell(
                  onTap: _save,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      color: AppColors.mainColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildTextInput(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          TextField(
            controller: controller,
            cursorColor: Colors.black,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: const Color.fromARGB(245, 245, 245, 245),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }
}
