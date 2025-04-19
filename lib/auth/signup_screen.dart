import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth/auth_service.dart';

class SignupScreen extends StatefulWidget {
  SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final nameCtrl = TextEditingController(); // For full name
  bool _obscurePassword = true;
  bool _showPasswordTimerActive = false;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF1C1F2E),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Image.asset('assets/logo.png', height: 100), // Optional logo
                const SizedBox(height: 16),
                const Text(
                  "Create your account",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 24),

                // Full Name
                TextField(
                  controller: nameCtrl,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFF2C3144),
                    labelText: "Full Name",
                    labelStyle: const TextStyle(color: Colors.white70),
                    prefixIcon: const Icon(Icons.person, color: Colors.white70),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.yellow),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Email
                TextField(
                  controller: emailCtrl,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFF2C3144),
                    labelText: "Email Address",
                    labelStyle: const TextStyle(color: Colors.white70),
                    prefixIcon: const Icon(Icons.email, color: Colors.white70),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.yellow),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Password
                TextField(
                  controller: passCtrl,
                  obscureText: _obscurePassword,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFF2C3144),
                    labelText: "Password",
                    labelStyle: const TextStyle(color: Colors.white70),
                    prefixIcon: const Icon(Icons.lock, color: Colors.white70),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.yellow),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        color: Colors.white70,
                      ),
                      onPressed: _togglePasswordVisibility,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Terms
                Row(
                  children: const [
                    Icon(Icons.check_circle, color: Colors.amber, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          text: "I have read & agreed to DayTask ",
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                          children: [
                            TextSpan(
                              text: "Privacy Policy, Terms & Condition",
                              style: TextStyle(color: Colors.amber, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Sign Up Button
                ElevatedButton(
                  onPressed: () async {
                    if (_validateInputs()) {
                      try {
                        await auth.signUp(emailCtrl.text, passCtrl.text);
                        Navigator.pop(context);
                      } catch (e) {
                        print(e);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Signup failed")),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero), // Square corners
                  ),
                  child: const Text("Sign Up", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                ),

                const SizedBox(height: 16),
                const Divider(color: Colors.grey),
                const SizedBox(height: 8),

                // Google Sign-In Button
                OutlinedButton.icon(
                  onPressed: () {
                    // Optional: Add Google sign-up logic
                  },
                  icon: const Icon(Icons.g_mobiledata, color: Colors.white),
                  label: const Text("Google"),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero), // Square corners
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),
                const SizedBox(height: 12),

                // Back to Login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? ", style: TextStyle(color: Colors.white70)),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text(
                        "Log In",
                        style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Function to toggle password visibility
  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
    // Automatically hide password after 5 seconds if it was shown
    if (!_obscurePassword && !_showPasswordTimerActive) {
      _showPasswordTimerActive = true;
      Future.delayed(const Duration(seconds: 5), () {
        setState(() {
          _obscurePassword = true;
          _showPasswordTimerActive = false;
        });
      });
    }
  }

  // Validate user inputs
  bool _validateInputs() {
    if (nameCtrl.text.isEmpty) {
      _showErrorSnackBar("Full Name cannot be empty");
      return false;
    }
    if (emailCtrl.text.isEmpty || !RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$").hasMatch(emailCtrl.text)) {
      _showErrorSnackBar("Please enter a valid email address");
      return false;
    }
    if (passCtrl.text.isEmpty || passCtrl.text.length<6) {
      _showErrorSnackBar("Password must be of 6 digit");
      return false;
    }
    return true;
  }

  // Show error message in a SnackBar
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
