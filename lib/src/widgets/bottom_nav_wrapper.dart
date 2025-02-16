import 'package:flutter/material.dart';

import '../pages/account/my_profile.dart';
import '../pages/cart_page.dart';
import '../pages/categories_page.dart';
import '../pages/home_view.dart';
import '../pages/settings_page.dart';
import '../widgets/bottom_nav_bar.dart';

class BottomNavWrapper extends StatefulWidget {
  const BottomNavWrapper({super.key});

  @override
  BottomNavWrapperState createState() => BottomNavWrapperState();
}

class BottomNavWrapperState extends State<BottomNavWrapper> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeView(),
    CategoriesPage(),
    CartPage(),
    MyProfilePage(),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
