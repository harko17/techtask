import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'auth/auth_service.dart';
import 'dashboard/dashboard_screen.dart';
import 'auth/login_screen.dart';
import 'app/theme.dart';

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
            ChangeNotifierProvider(create: (_) => TaskProvider()), // Add TaskProvider here
          ],
      child: MyApp(),),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthService>(
      create: (_) => AuthService(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Task Manager',
        theme: appTheme,
        home: Consumer<AuthService>(
          builder: (context, auth, _) {
            return auth.isLoggedIn ? DashboardScreen() : LoginScreen();
          },
        ),
      ),
    );
  }
}
