import 'package:flutter/material.dart';
import 'package:flutter_appd106d1/app_colors.dart';
import 'package:flutter_appd106d1/app_url.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ContactUs extends StatefulWidget {
  const ContactUs({super.key});

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  List constacts = [];
  @override
  void initState() {
    super.initState();
    getContacts();
  }

  Future<void> getContacts() async {
    EasyLoading.show(status: 'loading...');
    await Future.delayed(const Duration(seconds: 1));
    var url = Uri.parse("${AppUrl.url}contact/");
    final res = await http.get(url);
    if (res.statusCode == 200) {
      EasyLoading.dismiss();
      setState(() {
        constacts = jsonDecode(res.body);
      });
    } else {
      EasyLoading.showError('Failed to get contacts');
    }
  }
  Future<void> deleteContact(int id) async{
    EasyLoading.show(status: 'deleting...');
    await Future.delayed(const Duration(seconds: 1));
    var url = Uri.parse("${AppUrl.url}contact/$id");
    final res = await http.delete(url);
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      if(data['success'] == 1) {
        getContacts();
        EasyLoading.showSuccess("${data['msg_success']}");
      }else{
        EasyLoading.showSuccess("${data['msg_error']}");

      }
    }else{
        EasyLoading.showError("Failed to delete contacts");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Us'),
      ),
      body: ListView.builder(
          itemBuilder: (context, index) {
            final contact = constacts[index];
            return ListTile(
              leading: Image.network(
                  "${AppUrl.url}contact/images/${contact['contactImage']}",
                  width: 50,
                  height: 50),
              title: Text(contact['contactName']),
              subtitle: Text(contact['contactNumber']),
              trailing: PopupMenuButton<String>(
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'Edit', child: ListTile(
                     leading: Icon(Icons.edit, color: AppColors.mainColor,)
                  )),
                  const PopupMenuItem(value: 'Delete', child: ListTile(
                    leading: Icon(Icons.delete, color: AppColors.red,)
                  )),
                  const PopupMenuItem(
                      value: 'Add to favorites',
                      child: ListTile(
                            leading: Icon(Icons.favorite, color: AppColors.black,)
                      )),
                ],
              ),
            );
          },
          itemCount: constacts.length),
    );
  }
}
