import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Planificateur_Familial/src/providers/family_provider.dart';
import 'package:Planificateur_Familial/src/providers/grocery_list_provider.dart';
import 'package:Planificateur_Familial/src/providers/todo_list_provider.dart';
import 'package:Planificateur_Familial/src/ui/screens/home/home_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FamilyProvider()),
        ChangeNotifierProvider(create: (_) => ListProvider()),
        ChangeNotifierProvider(create: (_) => TodoListProvider()),
      ],
      child: MaterialApp(
        title: 'Planificateur Familial',
        theme: ThemeData(
          fontFamily: 'Roboto',
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
