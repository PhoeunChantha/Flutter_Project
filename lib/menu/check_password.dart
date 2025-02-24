import 'package:flutter/material.dart';
import 'package:flutter_appd106d1/app_colors.dart';

class CheckPassword extends StatefulWidget {
  const CheckPassword({super.key});

  @override
  State<CheckPassword> createState() => _CheckPasswordState();
}

class _CheckPasswordState extends State<CheckPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Current password'),
      ),
      body: Column(children: <Widget>[
        Expanded(
          child: Container(
            color: Colors.blue,
          ),
        ),
        Container(
          height: 70,
          margin: const EdgeInsets.all(10.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.mainColor,
            ),
            onPressed: (){},
            child: const Text(
              'continue', 
              style: TextStyle(color: AppColors.white),
            ),
          ),
        ),
      ],),
    );
  }
}