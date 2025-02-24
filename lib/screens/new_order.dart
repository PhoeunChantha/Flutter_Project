import 'package:flutter/material.dart';
class NewOrder extends StatefulWidget {
  const NewOrder({super.key});
  @override
  State<NewOrder> createState() => _NewOrderState();
}
class _NewOrderState extends State<NewOrder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Order'),
      ),
      body: ListView(),
    );
  }
}