import 'package:flutter/material.dart';
class TopNews extends StatefulWidget {
  const TopNews({super.key});
  @override
  State<TopNews> createState() => _TopNewsState();
}
class _TopNewsState extends State<TopNews> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top News'),
      ),
      body: ListView(),
    );
  }
}