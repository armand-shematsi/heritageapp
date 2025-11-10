import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthScreen extends StatefulWidget {
  final VoidCallback? onAuthSuccess;
  
  const AuthScreen({Key? key, this.onAuthSuccess}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final AuthService _authService = AuthService();
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

      final response = await _authService.register(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        culturalBackground: _culturalBackgroundController.text.trim().isEmpty 
            ? null 
            : _culturalBackgroundController.text.trim(),
        currentLocation: _locationController.text.trim().isEmpty 
            ? null 
            : _locationController.text.trim(),
      );

      print('✅ Account created successfully: ${response['user']?['id']}');

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Account created successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Clear form
      _clearForm();

      // Trigger auth success callback
      if (widget.onAuthSuccess != null) {
        widget.onAuthSuccess!();
      }
    } catch (error) {
      print('❌ Signup error: $error');
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
      final response = await _authService.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      print('✅ Signed in successfully: ${response['user']?['id']}');

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Welcome back!'),
          backgroundColor: Colors.green,
        ),
      );

      // Clear form
      _clearForm();

      // Trigger auth success callback
      if (widget.onAuthSuccess != null) {
        widget.onAuthSuccess!();
      }
    } catch (error) {
      print('❌ Login error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login failed: $error'),
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