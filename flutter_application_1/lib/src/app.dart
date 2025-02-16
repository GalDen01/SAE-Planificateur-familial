import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Planificateur_Familial/src/providers/family_provider.dart';
import 'package:Planificateur_Familial/src/providers/grocery_list_provider.dart';
import 'package:Planificateur_Familial/src/providers/todo_list_provider.dart';
import 'package:Planificateur_Familial/src/providers/auth_provider.dart';
import 'package:Planificateur_Familial/src/providers/weather_provider.dart';
import 'package:Planificateur_Familial/src/providers/ocr_provider.dart';
import 'package:Planificateur_Familial/src/providers/user_provider.dart';
import 'package:Planificateur_Familial/src/ui/screens/home/home_screen.dart';
import 'package:Planificateur_Familial/src/ui/screens/auth/login_screen.dart';
import 'package:Planificateur_Familial/src/ui/screens/auth/wrapper_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => FamilyProvider()),
        ChangeNotifierProvider(create: (_) => GroceryListProvider()),
        ChangeNotifierProvider(create: (_) => TodoListProvider()),
        ChangeNotifierProvider(create: (_) => WeatherProvider()),
        ChangeNotifierProvider(create: (_) => OcrProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        title: 'Planificateur Familial',
        theme: ThemeData(fontFamily: 'Roboto'),
        initialRoute: '/',
        routes: {
          '/': (context) => const WrapperScreen(),
          '/home': (context) => const HomeScreen(),
          '/login': (context) => const LoginScreen(),
        },
      ),
    );
  }
}
