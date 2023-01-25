import 'package:flutter/material.dart';
import 'package:bookmark/google_sheets_api.dart';
import 'package:bookmark/homepage.dart';

// credentials

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  GoogleSheetsApi().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      theme: ThemeData(primarySwatch: Colors.pink),
      
    );
  }
}