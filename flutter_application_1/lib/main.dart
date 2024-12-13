import 'package:Planificateur_Familial/src/providers/grocery_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'src/screens/home_screen.dart';
import 'src/providers/family_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FamilyProvider()),
        ChangeNotifierProvider(create: (_) => ListProvider()),
      ],
      child: const MyApp(),
    ),
  );
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
