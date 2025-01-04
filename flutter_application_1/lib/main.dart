import 'package:flutter/material.dart';
import 'package:Planificateur_Familial/src/app.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://jyeysdflargvkirkjmbe.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp5ZXlzZGZsYXJndmtpcmtqbWJlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzUwMzIxMDUsImV4cCI6MjA1MDYwODEwNX0.BlHBvxXMooEB32CsVv_h67P-DmoHAyWrsH9kV5iRuL4',
  );

  runApp(const MyApp());
}
