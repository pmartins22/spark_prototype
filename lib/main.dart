import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spark_prototype/login.dart';
import 'package:spark_prototype/pages/menu.dart';
import 'package:spark_prototype/pages/profile_page.dart';
import 'package:spark_prototype/pages/search.dart';
import 'package:spark_prototype/signup.dart';
import 'package:spark_prototype/splash_screen.dart';

import 'map_screen.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      routes: {
        '/home': (context) => Menu(),
        '/profile': (context) => ProfilePage(),
        '/map': (context) => MapScreen(),
        '/search': (context) => Search(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignupPage(),
      },
      home: const SplashScreen(),
    );
  }
}