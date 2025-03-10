import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Planificateur_Familial/src/providers/auth_provider.dart';
import 'package:Planificateur_Familial/src/ui/screens/home/home_screen.dart';
import 'package:Planificateur_Familial/src/ui/screens/auth/login_screen.dart';

class WrapperScreen extends StatefulWidget {
  const WrapperScreen({super.key});

  @override
  State<WrapperScreen> createState() => _WrapperScreenState();
}

class _WrapperScreenState extends State<WrapperScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AuthProvider>().silentSignIn();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    if (authProvider.isLoggedIn) {
      return const HomeScreen();
    } else {
      return const LoginScreen();
    }
  }
}
