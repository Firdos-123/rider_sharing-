import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rider/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) =>
      print("Firebase Initialization completed..."));
  runApp(const MyApp()); // Removed 'key: null'
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key); // Explicitly passing the key

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashPage(),
    );
  }
}
