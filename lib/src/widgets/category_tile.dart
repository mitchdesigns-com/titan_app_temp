import 'package:flutter/material.dart';

import 'google_font_text.dart';

class CategoryTile extends StatelessWidget {
  final String categoryName;
  final String categorySlug;
  final String imageUrl;

  const CategoryTile({
    super.key,
    required this.categoryName,
    required this.categorySlug,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: GestureDetector(
        // Wrap the entire content with GestureDetector
        onTap: () {
          // Your onTap logic here (e.g., navigation)
          print("Tapped on $categoryName, slug: $categorySlug");
          Navigator.pushNamed(
            context,
            '/category_details',
            arguments: categorySlug,
          );
        },
        child: AspectRatio(
          aspectRatio: 124 / 160,
          child: ClipRRect(
            // ClipRRect now wraps everything
            borderRadius: BorderRadius.circular(6), // Apply borderRadius here
            child: Stack(
              children: [
                Image.network(
                  // Use Image.network for URLs
                  imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  errorBuilder: (context, object, stackTrace) =>
                      const Icon(Icons.error), // Handle errors
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                ),
                Positioned.fill(
                  // Positioned.fill covers the entire Stack
                  child: Container(
                    color:
                        Colors.black.withAlpha(192),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: GoogleFontText(
                      text: categoryName,
                      style: const TextStyle(
                        // Added const for performance
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
