import 'dart:io';
import 'package:flutter/material.dart';
// ... other imports

class NoNetworkScreen extends StatefulWidget {
  const NoNetworkScreen({super.key});

  @override
  State<NoNetworkScreen> createState() => _NoNetworkScreenState();
}

class _NoNetworkScreenState extends State<NoNetworkScreen> {
  Future<void> _refresh() async {
    print("Refreshing...");
    await Future.delayed(const Duration(seconds: 2)); // Simulate network check

    if (mounted) {
      setState(() {}); // Rebuild to reflect any network changes

      // Check network connectivity again after the delay
      if (await _checkConnectivity()) { // Use your connectivity check function
        // Navigate back to the home screen.  Use appropriate navigation.
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
        // OR
        // Navigator.of(context).pop(); // If you want to go back one screen
      }
    }
  }

  Future<bool> _checkConnectivity() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.wifi_off, size: 100, color: Colors.grey),
                SizedBox(height: 20),
                Text(
                  "No Internet Connection",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text("Please check your internet connection and try again."),
              ],
            ),
          ),
        ),
      ),
    );
  }
}