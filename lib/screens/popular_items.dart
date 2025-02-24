import 'package:flutter/material.dart';
class PopularItems extends StatefulWidget {
  const PopularItems({super.key});
  @override
  State<PopularItems> createState() => _PopularItemsState();
}
class _PopularItemsState extends State<PopularItems> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular Items'),
      ),
      body: ListView(),
    );
  }
}