import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: const Color(0x0A000000),
            blurRadius: 6,
            offset: const Offset(0, -2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -5,
            right: _calculateShadowPosition(
                    currentIndex, MediaQuery.of(context).size.width) +
                16,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              height: 52,
              width: 52,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x0A000000),
                    blurRadius: 6,
                    offset: const Offset(0, -2),
                    spreadRadius: 0,
                  ),
                ],
              ),
            ),
          ),
          // BottomNavigationBar is the last widget, so it will appear above the shadow
          Builder(builder: (context) {
            return BottomNavigationBar(
              currentIndex: currentIndex,
              onTap: onTap,
              elevation: 0,
              backgroundColor: Colors.white,
              type: BottomNavigationBarType.fixed,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              items: [
                _buildNavItem(context, 'assets/images/icons/home.svg','assets/images/icons/home_active.svg', "الرئيسية", 0),
                _buildNavItem(context, 'assets/images/icons/category.svg','assets/images/icons/category_active.svg', "الاقسام", 1),
                _buildNavItem(context, 'assets/images/icons/cart.svg','assets/images/icons/cart_active.svg', "عربة التسوق", 2),
                _buildNavItem(context, 'assets/images/icons/account.svg','assets/images/icons/account_active.svg', "حسابي", 3),
                _buildNavItem(context, 'assets/images/icons/more.svg','assets/images/icons/more_active.svg', "المزيد", 4),
              ],
            );
          }),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(BuildContext context,
      String inactiveIconPath, String activeIconPath, String label, int index) {
    // Determine the fill color based on whether the item is selected
    final iconColor = currentIndex == index
        ? Theme.of(context).colorScheme.primary // Active color (selected)
        : Colors.grey; // Inactive color (unselected)
    final iconPath = currentIndex == index ? activeIconPath : inactiveIconPath;

    return BottomNavigationBarItem(
      icon: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SvgPicture.asset(
                iconPath,
                colorFilter: ColorFilter.mode(
                  iconColor,
                  BlendMode.srcIn,
                ),
                width: 20,
                height: 20,
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            label,
            style: GoogleFonts.vazirmatn(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: iconColor, // Ensure the label color matches the icon
            ),
          ),
        ],
      ),
      label: "",
    );
  }

  // Helper function to calculate the position of the shadow
  double _calculateShadowPosition(int index, double screenWidth) {
    final itemWidth = screenWidth / 5;
    return index * itemWidth;
  }
}
