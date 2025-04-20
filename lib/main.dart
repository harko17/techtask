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
    url: 'YOUR_SUPABASE_PROJECT_LINK',
    anonKey: 'YOUR_API_KEY',
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
