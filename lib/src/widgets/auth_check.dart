import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/services/auth_service.dart';

class AuthCheck extends StatefulWidget {
  final Widget child; // The widget to display if authenticated
  const AuthCheck({super.key, required this.child});

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  final _authService = AuthService();
  bool _isAuthenticated = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final token = await _authService.secureStorage.read(key: 'jwt');
    setState(() {
      _isAuthenticated = token != null;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator()); // Show loading indicator
    } else if (_isAuthenticated) {
      return widget.child; // Display the home view
    } else {
      // Redirect to login/signup
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false); // Or /signup
      return const Center(child: CircularProgressIndicator()); // to avoid blank screen
    }
  }
}