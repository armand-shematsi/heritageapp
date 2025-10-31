import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final SupabaseClient _supabase = Supabase.instance.client;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _culturalBackgroundController = TextEditingController();
  final _locationController = TextEditingController();

  bool _isLoading = false;
  bool _isSignUp = false;

  Future<void> _signUp() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);
    try {
      print('🔄 Starting signup process...');

      // 1. Create auth user
      final authResponse = await _supabase.auth.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      print('✅ Auth user created: ${authResponse.user?.id}');

      if (authResponse.user != null) {
        // 2. Create user profile in database
        final response = await _supabase
            .from('users')
            .insert({
          'id': authResponse.user!.id,
          'email': _emailController.text.trim(),
          'name': _nameController.text.trim(),
          'cultural_background': _culturalBackgroundController.text.trim(),
          'current_location': _locationController.text.trim(),
          'languages': ['English'],
        })
            .select();

        print('✅ User profile created in database: $response');

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Account created successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        // Clear form
        _clearForm();

        // Navigation happens automatically via the StreamBuilder in AuthWrapper
      }
    } on AuthException catch (error) {
      print('❌ Auth error: ${error.message}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message),
          backgroundColor: Colors.red,
        ),
      );
    } catch (error) {
      print('❌ General error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to create account: $error'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _signIn() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      print('✅ Signed in successfully: ${response.user?.id}');

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Welcome back!'),
          backgroundColor: Colors.green,
        ),
      );

      // Clear form
      _clearForm();

      // Navigation happens automatically via the StreamBuilder in AuthWrapper
    } on AuthException catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message),
          backgroundColor: Colors.red,
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: $error'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _clearForm() {
    _emailController.clear();
    _passwordController.clear();
    if (_isSignUp) {
      _nameController.clear();
      _culturalBackgroundController.clear();
      _locationController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Heritage App - Authentication'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo/Header
              Icon(Icons.account_tree, size: 80, color: Colors.blue),
              SizedBox(height: 16),
              Text(
                'My Heritage',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Preserve your cultural legacy',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 40),

              // Form
              if (_isSignUp) ...[
                _buildTextField(_nameController, 'Full Name', Icons.person),
                SizedBox(height: 16),
                _buildTextField(_culturalBackgroundController, 'Cultural Background (e.g., East African)', Icons.flag),
                SizedBox(height: 16),
                _buildTextField(_locationController, 'Current Location', Icons.location_on),
                SizedBox(height: 16),
              ],

              _buildTextField(_emailController, 'Email', Icons.email, TextInputType.emailAddress),
              SizedBox(height: 16),
              _buildTextField(_passwordController, 'Password', Icons.lock, null, true),
              SizedBox(height: 24),

              // Action Button
              if (_isLoading)
                CircularProgressIndicator()
              else
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isSignUp ? _signUp : _signIn,
                    child: Text(
                      _isSignUp ? 'Create Account' : 'Sign In',
                      style: TextStyle(fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),

              SizedBox(height: 20),

              // Toggle between Sign In/Sign Up
              TextButton(
                onPressed: _isLoading ? null : () => setState(() => _isSignUp = !_isSignUp),
                child: Text(
                  _isSignUp
                      ? 'Already have an account? Sign In'
                      : 'Don\'t have an account? Create One',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon,
      [TextInputType? keyboardType, bool obscureText = false]) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      keyboardType: keyboardType,
      obscureText: obscureText,
      enabled: !_isLoading,
    );
  }
}