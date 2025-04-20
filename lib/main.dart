import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'auth/auth_service.dart';
import 'dashboard/dashboard_screen.dart';
import 'auth/login_screen.dart';
import 'app/theme.dart';
import 'app/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://zvphhgdtwqsugltshhzb.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inp2cGhoZ2R0d3FzdWdsdHNoaHpiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDUwNTk1MTgsImV4cCI6MjA2MDYzNTUxOH0.BGTLAHXlGjZIJ532o41YDSBYL0MHuJsp_WATvTUcslg',
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Manager',
      theme: lightTheme, // from your app/theme.dart
      darkTheme: darkTheme, // add this in theme.dart
      themeMode: themeProvider.themeMode,
      home: Consumer<AuthService>(
        builder: (context, auth, _) {
          return auth.isLoggedIn ? const DashboardScreen() : const LoginScreen();
        },
      ),
    );
  }
}
