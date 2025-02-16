import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'pages/account/my_profile.dart';
import 'pages/category_details_page.dart';
import 'pages/login_page.dart';
import 'pages/product_details_page.dart';
import 'pages/settings_page.dart';
import 'pages/signup_page.dart';
import 'pages/splash_screen.dart';
import 'themes/language_provider.dart';
import 'themes/theme_provider.dart';
import 'widgets/auth_check.dart';
import 'widgets/bottom_nav_wrapper.dart';
import 'widgets/no_network_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ],
      child: Consumer<LanguageProvider>(
        builder: (context, languageProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: Provider.of<ThemeProvider>(context).themeData,
            locale: languageProvider.locale,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
              Locale('ar'),
            ],
            home: _buildHomeScreen(),
            routes: {
              '/splash': (context) => SplashScreen(),
              '/login': (context) => const LoginPage(),
              '/sign-up': (context) => const SignUpPage(),
              '/home_view': (context) => const AuthCheck(child: BottomNavWrapper()),
              '/my_profile': (context) => const AuthCheck(child: MyProfilePage()),
              '/settings': (context) => const SettingsPage(),
              '/product_details': (context) => const ProductDetailsPage(),
              '/category_details': (context) => const CategoryDetailsPage(),
            },
          );
        },
      ),
    );
  }

  Widget _buildHomeScreen() {
    return FutureBuilder<bool>( // Check for network connectivity
      future: Future.delayed(const Duration(seconds: 2), _checkConnectivity), // Delay the check
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator()); // Show loading indicator
        } else if (snapshot.data == true) {
          return const AuthCheck(child: BottomNavWrapper()); // Show app if connected
        } else {
          return const NoNetworkScreen(); // Show no network screen if not connected
        }
      },
    );
  }

  Future<bool> _checkConnectivity() async {
    try {
      final result = await InternetAddress.lookup('google.com'); // Check internet
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false; // No internet connection
    }
  }
}
