import 'package:flutter/material.dart';
import 'src/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plannificateur Familial',
      theme: ThemeData(
        fontFamily: 'Roboto', // Par exemple, si tu as une police spécifique
      ),
      home: const HomeScreen(),
    );
  }
}
