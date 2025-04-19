String? validateEmail(String? email) {
  if (email == null || !email.contains('@')) return 'Enter a valid email';
  return null;
}

String? validatePassword(String? password) {
  if (password == null || password.length < 6) return 'Password too short';
  return null;
}
