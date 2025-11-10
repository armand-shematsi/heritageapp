import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/family_tree_screen.dart';
import 'screens/community_screen.dart';
import 'screens/mental_health_screen.dart';
import 'screens/events_screen.dart';
import 'screens/search_screen.dart';
import 'screens/auth_screen.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyHeritageApp());
}

class MyHeritageApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Heritage',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Inter',
        scaffoldBackgroundColor: Colors.grey[50],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.blue),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
        ),
      ),
      home: AuthWrapper(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AuthWrapper extends StatefulWidget {
  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  final AuthService _authService = AuthService();
  bool _isInitializing = true;
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _checkInitialAuth();
  }

  Future<void> _checkInitialAuth() async {
    // Check if user is already authenticated
    _isAuthenticated = _authService.isAuthenticated;
    if (_isAuthenticated) {
      // Verify token is still valid by fetching user
      final user = await _authService.getCurrentUser();
      _isAuthenticated = user != null;
    }
    
    setState(() {
      _isInitializing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitializing) {
      return _buildLoadingScreen();
    }

    if (_isAuthenticated) {
      return MainNavigationScreen();
    }

    return AuthScreen(
      onAuthSuccess: () {
        setState(() {
          _isAuthenticated = true;
        });
      },
    );
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              strokeWidth: 4,
            ),
            SizedBox(height: 20),
            Text(
              'Loading Heritage App...',
              style: TextStyle(
                fontSize: 18,
                color: Colors.blue[800],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Main Navigation Screen with actual screens
class MainNavigationScreen extends StatefulWidget {
  @override
  _MainNavigationScreenState createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  final AuthService _authService = AuthService();

  // Use your actual screens
  final List<Widget> _screens = [
    HomeScreen(),
    CommunityScreen(),
    FamilyTreeScreen(),
    MentalHealthScreen(),
    EventsScreen(),
  ];

  // Method to handle search from any screen
  void _openSearchScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => SearchScreen()),
    );
  }

  // Sign out method
  Future<void> _signOut() async {
    try {
      await _authService.logout();
      print('✅ User signed out successfully');
      // Navigate back to auth screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => AuthWrapper()),
      );
    } catch (error) {
      print('❌ Error signing out: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Heritage'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: _openSearchScreen,
            tooltip: 'Search',
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _signOut,
            tooltip: 'Sign Out',
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: _currentIndex == 0 ? _buildFloatingActionButton() : null,
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) => setState(() => _currentIndex = index),
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      unselectedLabelStyle: TextStyle(fontSize: 12),
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people_outline),
          activeIcon: Icon(Icons.people),
          label: 'Community',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_tree_outlined),
          activeIcon: Icon(Icons.account_tree),
          label: 'Family Tree',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.psychology_outlined),
          activeIcon: Icon(Icons.psychology),
          label: 'Wellness',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.event_outlined),
          activeIcon: Icon(Icons.event),
          label: 'Events',
        ),
      ],
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: _openSearchScreen,
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      child: Icon(Icons.search, size: 28),
      elevation: 2,
    );
  }
}