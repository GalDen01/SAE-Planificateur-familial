import 'package:flutter/material.dart';
import 'package:Planificateur_Familial/src/app.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


// commande pour run flutter run -d chrome --web-port=1234 --web-hostname=localhost --dart-define=SUPABASE_URL=https://jyeysdflargvkirkjmbe.supabase.co --dart-define=SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp5ZXlzZGZsYXJndmtpcmtqbWJlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzUwMzIxMDUsImV4cCI6MjA1MDYwODEwNX0.BlHBvxXMooEB32CsVv_h67P-DmoHAyWrsH9kV5iRuL4
// commande pour run flutter run --dart-define=SUPABASE_URL=https://jyeysdflargvkirkjmbe.supabase.co --dart-define=SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp5ZXlzZGZsYXJndmtpcmtqbWJlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzUwMzIxMDUsImV4cCI6MjA1MDYwODEwNX0.BlHBvxXMooEB32CsVv_h67P-DmoHAyWrsH9kV5iRuL4

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const supabaseUrl = String.fromEnvironment('SUPABASE_URL', defaultValue: '');
  const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: '');

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );
  runApp(const MyApp());
}
