import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_appd106d1/app_colors.dart';
import 'package:flutter_appd106d1/app_url.dart';
import 'package:flutter_appd106d1/screens/contact_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddContact extends StatefulWidget {
  const AddContact({super.key});

  @override
  State<AddContact> createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  TextEditingController txtcontactname = TextEditingController();
  TextEditingController txtphone = TextEditingController();
  TextEditingController txtemail = TextEditingController();
  final _keyForm = GlobalKey<FormState>();
  String _image = 'default.png';
  File? _newImage;
  final picker = ImagePicker();
  Future<void> _changeImage() async {
    final imageFile = await picker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      setState(() {
        _newImage = File(imageFile.path);
      });
      final bytes = await _newImage!.readAsBytes();
      _image = base64Encode(bytes);
    }
  }

  Future<void> _saveContact(
      String name, String phone, String email, String image) async {
    var uri = Uri.parse("${AppUrl.url}contact/");
    final res = await http.post(uri, body: jsonEncode({
      'contactName': name,
      'contactNumber': phone,
      'contactEmail': email,
      'contactImage': image,
    }),);
    EasyLoading.show(status: 'Creating contact...');
    await Future.delayed(const Duration(seconds: 2));

    if (res.statusCode == 200) {
      //showDialog(context: context, builder: (context) => AlertDialog(
        //content: Text(res.body)));
      final data = jsonDecode(res.body);
      if (data['success'] == 1) {
        EasyLoading.showSuccess("${data['msg_success']}");
        if (!mounted) return;
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const ContactScreen(),
            ));
      } else {
        EasyLoading.showError("${data['msg_error']}");
        if (!mounted) return;
      }
    } else {
      EasyLoading.showError('Failed to create contact');
    }
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Contact'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const ContactScreen(),
              ),
            );
          },
        ),
      ),
      body: Form(
        key: _keyForm,
        child: Column(
          children: [
            Expanded(flex: 2, child: topPortion(_image)),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: ListView(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.fromLTRB(10, 30, 10, 10),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Contact Name is required!';
                          }
                          return null;
                        },
                        controller: txtcontactname,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Contact Name',
                          prefixIcon: Icon(Icons.account_circle),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Contact Number is required!';
                          }
                          return null;
                        },
                        controller: txtphone,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Contact Number',
                          prefixIcon: Icon(Icons.phone_in_talk),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email is required!';
                          }
                          return null;
                        },
                        controller: txtemail,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email),
                        ),
                      ),
                    ),
                    Container(
                      height: 56,
                      margin: const EdgeInsets.fromLTRB(10, 25, 10, 25),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.blue,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                          ),
                        ),
                        onPressed: () {
                          if (_keyForm.currentState!.validate()) {
                            String name = txtcontactname.text;
                            String phone = txtphone.text;
                            String email = txtemail.text;
                            _saveContact(name, phone, email, _image);
                          }
                        },
                        child: const Text(
                          'Save',
                          style: TextStyle(color: AppColors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget topPortion(String image) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 50),
          decoration: const BoxDecoration(
            color: AppColors.blue,
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
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    border: Border.all(
                      width: 3.0,
                      color: AppColors.blue,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    // varName = (condtion) ? statement1 : statement2;
                    child: (_newImage != null)
                        ? Image.file(_newImage!)
                        : Image.network(('${AppUrl.url}images/$image')),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.white,
                    child: InkWell(
                      onTap: () {
                        _changeImage();
                      },
                      child: Container(
                        margin: const EdgeInsets.all(8.0),
                        child: const Icon(Icons.camera_alt),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
