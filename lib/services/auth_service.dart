import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final supabase = Supabase.instance.client;
  
  static const defaultImageUrl = 'user-images/default.png';

  Future<void> signUp({
    required String email,
    required String name,
    required String password,
    required String confirmPassword,
  }) async {
    // Validate inputs
    if (password != confirmPassword) throw 'Passwords do not match';
    if (password.length < 6) throw 'Password must be at least 6 characters';
    if (!email.contains('@')) throw 'Invalid email address';

    try {
      // Sign up with Supabase auth
      final authResponse = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      // Handle case where user is null
      if (authResponse.user == null) {
        throw 'Sign up failed: No user returned';
      }

      // Save user profile
      final userId = authResponse.user!.id;
      final response = await supabase.from('users').insert({
        'id': userId,
        'name': name,
        'email': email,
        'image_url': defaultImageUrl,
      });

      // Check for error in response
      if (response.error != null) {
        throw 'Profile creation failed: ${response.error!.message}';
      }
    } on AuthException catch (e) {
      // Handle Supabase auth errors
      throw e.message;
    } catch (e) {
      // Handle all other errors
      throw 'Sign up failed: $e';
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      if (response.user == null) {
        throw 'Sign in failed: Invalid credentials';
      }
    } on AuthException catch (e) {
      throw e.message;
    }
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    try {
      await supabase.auth.resetPasswordForEmail(email);
    } on AuthException catch (e) {
      throw e.message;
}
}
}
