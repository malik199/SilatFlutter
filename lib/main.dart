import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';

import 'login/login_page.dart';

void main() {
  /*WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp().then((_) {
    FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);
  });*/
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Silat App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            textStyle: TextStyle(
              fontSize: 20.0,
              height: 1,
            ),
            padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
          ),
        ),
        textTheme: TextTheme(
          displayLarge: TextStyle(
            height: 1,
            fontSize: 42.0,
            color: Colors.blue.shade700,
            fontWeight: FontWeight.w500,
          ),
          bodyLarge: TextStyle(
              fontSize: 18.0,
              height: 1,
          ),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.green,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            textStyle: TextStyle(
              fontSize: 24.0,
            ),
            padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
          ),
        ),
        textTheme: TextTheme(
          displayLarge: TextStyle(
            fontSize: 46.0,
            color: Colors.blue.shade200,
            fontWeight: FontWeight.w500,
          ),
          bodyLarge: TextStyle(fontSize: 18.0, color: Colors.white),
        ),
      ),
      themeMode: ThemeMode.dark,
      home: LoginPage(),
    );
  }
}
