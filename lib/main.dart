import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_appd106d1/app_colors.dart';
import 'package:flutter_appd106d1/screens/current_password.dart';
import 'package:flutter_appd106d1/screens/home_screen.dart';
import 'package:flutter_appd106d1/screens/login_user.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sp = await SharedPreferences.getInstance();
  final checklogin = sp.getBool("isLoggedIn") ?? false;
  runApp(MyApp(isLoggedIn: checklogin));
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = AppColors.mainColor
    ..backgroundColor = Colors.black
    ..indicatorColor = AppColors.white
    ..textColor = AppColors.white
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
  // ..customAnimation = CustomAnimation();
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login User',
      // varname = (condition) ? result_if_true : result_if_false;
      home: isLoggedIn ? const HomeScreen() : const LoginUser(),
      // home: const CurrentPassword(),
      theme: ThemeData.light().copyWith(
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.mainColor,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
      ),
      builder: EasyLoading.init(),
    );
  }
}
