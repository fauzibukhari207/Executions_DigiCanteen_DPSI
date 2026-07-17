import 'package:flutter/material.dart';
import 'profile_page.dart';

void main() {
  runApp(const Praktikum5App());
}

class Praktikum5App extends StatelessWidget {
  const Praktikum5App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Praktikum 5',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFFDF6EC),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF5C3D1E),
          surface: Color(0xFFFFFAF3),
        ),
      ),
      home: const ProfilePage(),
    );
  }
}