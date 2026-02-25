import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spark_prototype/components/search_page_app_bar.dart';
import 'package:spark_prototype/pages/menu.dart';
import 'package:spark_prototype/pages/profile_page.dart';
import 'package:spark_prototype/pages/search.dart';
import 'package:spark_prototype/splash_screen.dart';

import 'map.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});



  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/home': (context) => Menu(),
        '/profile': (context) => ProfilePage(),
        '/map': (context) => MapScreen(),
        '/search': (context) => Search(),
      },
      home: const SplashScreen(),
    );
  }
}