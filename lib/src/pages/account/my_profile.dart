import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/services/auth_service.dart'; // Import your AuthService

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  final _authService = AuthService(); // Create an instance of your AuthService
  Map<String, dynamic>? _profileData;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadProfileData(); // Load profile data when the page initializes
  }

  Future<void> _loadProfileData() async {
    if (_isLoading) return; // Prevent concurrent loading

    setState(() {
      _isLoading = true;
    });

    try {
      final profileData = await _authService.getProfileData();
      print('profileData: $profileData');
      setState(() {
        _profileData = profileData;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      // This block is *crucial*
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: RefreshIndicator(
        // Wrap with RefreshIndicator
        onRefresh: _loadProfileData, // Call on refresh
        child: _buildBody(), // Extract body to a separate function
      ), // Show loading indicator
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_profileData != null) {
      final data = _profileData!;

      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${data['first_name'] ?? 'N/A'}'),
            Text('Last Name: ${data['last_name'] ?? 'N/A'}'),
            Text('Email: ${data['email'] ?? 'N/A'}'),
            Text('Phone: ${data['phone'] ?? 'N/A'}'),
            Text('Gender: ${data['gender'] ?? 'N/A'}'),
            Text(
                'Membership: ${data['membership']?['name'] ?? 'N/A'}'), // Nested access
            Text(
                'Birthday: ${data['bod_day']}/${data['bod_month']}/${data['bod_year'] ?? 'N/A'}'), // Combined date
            // ... display other profile data
          ],
        ),
      );
    } else {
      return const Center(child: Text("No data available"));
    }
  }
}
