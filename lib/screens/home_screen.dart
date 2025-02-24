import 'package:flutter/material.dart';
import 'package:flutter_appd106d1/app_colors.dart';
import 'package:flutter_appd106d1/app_url.dart';
import 'package:flutter_appd106d1/menu/navigation_menu.dart';
import 'package:flutter_appd106d1/screens/category_screen.dart';
import 'package:flutter_appd106d1/screens/contact_screen.dart';
import 'package:flutter_appd106d1/screens/favorite_items.dart';
import 'package:flutter_appd106d1/screens/group_screen.dart';
import 'package:flutter_appd106d1/screens/help_screen.dart';
import 'package:flutter_appd106d1/screens/my_orders.dart';
import 'package:flutter_appd106d1/screens/new_order.dart';
import 'package:flutter_appd106d1/screens/popular_items.dart';
import 'package:flutter_appd106d1/screens/product_screen.dart';
import 'package:flutter_appd106d1/screens/setting_screen.dart';
import 'package:flutter_appd106d1/screens/top_news.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String greettingmsg() {
    DateTime now = DateTime.now();
    var msg = "";
    int hours = now.hour;
    if (hours >= 12 && hours <= 16) {
      msg = "Good Afternoon!";
    } else if (hours > 16 && hours <= 24) {
      msg = "Good Evening!";
    } else {
      msg = "Good Morning!";
    }
    return msg;
  }

  String _fullname = '';
  String _profileImagePath = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _updateProfile() {
    setState(() {
      _loadUserData(); // Reload user data after edit
    });
  }

  Future<void> _loadUserData() async {
    final sp = await SharedPreferences.getInstance();
    setState(() {
      _fullname = sp.getString('USER_FULLNAME') ?? 'default-image';
      _profileImagePath =
          sp.getString('USER_IMAGE') ?? 'assets/images/default-image.png';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BBU STORE'),
        actions: [
          PopupMenuButton<int>(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 1,
                child: ListTile(
                  leading: Icon(Icons.add_shopping_cart),
                  title: Text('New Order'),
                ),
              ),
              const PopupMenuItem(
                value: 2,
                child: ListTile(
                  leading: Icon(Icons.share),
                  title: Text('Popular Items'),
                ),
              ),
              const PopupMenuItem(
                value: 3,
                child: ListTile(
                  leading: Icon(
                    Icons.favorite,
                    color: Colors.red,
                  ),
                  title: Text('Favorite Items'),
                ),
              ),
            ],
            onSelected: (value) {
              switch (value) {
                case 1:
                  // go to New Order screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NewOrder(),
                    ),
                  );
                  break;
                case 2:
                  // go to Popular Items screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PopularItems(),
                    ),
                  );
                  break;
                case 3:
                  // go to Favorite Items screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FavoriteItems(),
                    ),
                  );
                  break;
              }
            },
          )
        ],
      ),
      drawer: NavigationMenu(onProfileUpdated: _updateProfile),
      body: Container(
        color: AppColors.bgColor,
        child: Stack(
          children: <Widget>[
            // background
            Container(
              height: 80,
              decoration: const BoxDecoration(
                color: AppColors.mainColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
            ),
            // Contents
            ListView(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              children: <Widget>[
                Container(
                  height: 140,
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Card(
                    child: Stack(
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.all(10.0),
                          child: Text(
                            greettingmsg(),
                            style: const TextStyle(
                              color: AppColors.mainColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(10, 40, 10, 10),
                          child: Text('$_fullname'),
                        ),
                        Positioned(
                          left: 10,
                          bottom: 10,
                          child: Row(
                            children: <Widget>[
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.mainColor,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(6.0),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const MyOrders(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'My Orders'.toUpperCase(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              const SizedBox(width: 10),
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(6.0),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const TopNews(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Top News'.toUpperCase(),
                                  style: const TextStyle(
                                      color: AppColors.mainColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          bottom: 10,
                          child: CircleAvatar(
                            radius: 40,
                            backgroundColor: AppColors.mainColor,
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: ClipOval(
                                child: Image.network(
                                  '${AppUrl.url}images/$_profileImagePath',
                                  fit: BoxFit.cover,
                                  width: 72,
                                  height: 72,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(
                                    Icons.person,
                                    size: 40,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    // Card 1
                    cardBox('Contacts', Icons.person),
                    // Card 2
                    cardBox('Groups', Icons.people),
                    // Card 3
                    cardBox('Products', Icons.shopping_cart),
                    // Card 4
                    cardBox('Categories', Icons.playlist_add_check),
                    // Card 5
                    cardBox('Help', Icons.question_mark),
                    // Card 6
                    cardBox('Settings', Icons.settings),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget cardBox(String title, IconData icon) {
    return SizedBox(
      child: Card(
        // InkWell, InkResponse, GestureDesctor
        child: InkWell(
          onTap: () {
            if (title == 'Contacts') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ContactScreen(),
                ),
              );
            } else if (title == 'Groups') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const GroupScreen(),
                ),
              );
            } else if (title == 'Products') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProductScreen(),
                ),
              );
            } else if (title == 'Categories') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CategoryScreen(),
                ),
              );
            } else if (title == 'Help') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HelpScreen(),
                ),
              );
            } else if (title == 'Settings') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingScreen(),
                ),
              );
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: AppColors.mainColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(180),
                  ),
                ),
                child: Icon(
                  icon,
                  size: 52,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10.0),
              Text(
                title.toUpperCase(),
                style: const TextStyle(
                  color: AppColors.mainColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
