import 'package:movie_catalogue/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF090F32),
        ),
        // primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF090F32),
      ),
      home: HomeScreen(),
    );
  }
}
