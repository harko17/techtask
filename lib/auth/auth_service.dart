import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService extends ChangeNotifier {
  final SupabaseClient _client = Supabase.instance.client;

  bool get isLoggedIn => _client.auth.currentUser != null;

  Future<void> signUp(String email, String password) async {
    final res = await _client.auth.signUp(email: email, password: password);
    notifyListeners();
  }

  Future<void> signIn(String email, String password) async {
    await _client.auth.signInWithPassword(email: email, password: password);
    notifyListeners();
  }

  void signOut() async {
    await _client.auth.signOut();
    notifyListeners();
  }
}
