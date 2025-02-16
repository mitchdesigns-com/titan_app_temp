import 'package:flutter/material.dart';

class CustomCategoryWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 428,
      height: 207,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            width: double.infinity,
            child: Text(
              'الاقسام',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Color(0xFF1D2128),
                fontSize: 21,
                fontFamily: 'Vazirmatn',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildCategoryItem('شوكولاته', 'https://via.placeholder.com/124x160'),
                const SizedBox(width: 8),
                _buildCategoryItem('البان', 'https://via.placeholder.com/124x160'),
                const SizedBox(width: 8),
                _buildCategoryItem('ايس\nكريم', 'https://via.placeholder.com/124x160', true),
                const SizedBox(width: 8),
                _buildCategoryItem('حلويات\nغربية', 'https://via.placeholder.com/124x160'),
                const SizedBox(width: 8),
                _buildCategoryItem('حلويات\nشرقية', 'https://via.placeholder.com/124x160'),
                const SizedBox(width: 8),
                _buildCategoryItem('بقلاوة', 'https://via.placeholder.com/124x160'),
                const SizedBox(width: 8),
                _buildCategoryItem('كنافة\nوبسبوسة', 'https://via.placeholder.com/124x160'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(String text, String imageUrl, [bool isReversed = false]) {
    return Container(
      width: 124,
      height: 160,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: 124,
              height: 160,
              decoration: ShapeDecoration(
                gradient: LinearGradient(
                  begin: Alignment(0.00, -1.00),
                  end: Alignment(0, 1),
                  colors: [Colors.black, Colors.black.withOpacity(0)],
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              ),
            ),
          ),
          Positioned(
            left: isReversed ? 81 : 48,
            top: 9.69,
            child: Text(
              text,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: isReversed ? Color(0xFF425486) : Colors.white,
                fontSize: 18,
                fontFamily: 'Vazirmatn',
                fontWeight: FontWeight.w700,
                height: 1.20,
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: 124,
              height: 160,
              decoration: ShapeDecoration(
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
