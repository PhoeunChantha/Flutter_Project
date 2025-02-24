import 'package:flutter/material.dart';
class FavoriteItems extends StatefulWidget {
  const FavoriteItems({super.key});
  @override
  State<FavoriteItems> createState() => _FavoriteItemsState();
}
class _FavoriteItemsState extends State<FavoriteItems> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Items'),
      ),
      body: ListView(),
    );
  }
}