import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../themes/language_provider.dart';
import 'google_font_text.dart';

class ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final languageCode = Provider.of<LanguageProvider>(context).currentLanguage;

    return GestureDetector(
      onTap: () {
        if (product['slug'] != null) { // Check if slug exists before navigating
          Navigator.pushNamed(
            context,
            '/product_details',
            arguments: product['slug'],
          );
        } else {
          print("Product slug is missing for ${product['id']}"); // Log if missing
          // Optionally, show a snackbar or dialog to the user.
        }
      },
      child: Card( // Use Card widget for better visual appearance
        elevation: 2, // Add elevation for a subtle shadow
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: SizedBox( // Use SizedBox to set a specific size
          width: 186,
          height: 300,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect( // Clip image to rounded corners
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                    child: Image.network(
                      product['main_img']['src'] ?? '',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 186,
                      errorBuilder: (context, object, stackTrace) =>
                          const Icon(Icons.error), // Handle image errors
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
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: GoogleFontText(
                      text: product['name'][languageCode] ?? 'N/A',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: ListView(
                        physics: const NeverScrollableScrollPhysics(),
                        children: product['tags']?.map<Widget>((tag) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: tag['values']?.map<Widget>((value) {
                                      return GoogleFontText(
                                        text: value['name'][languageCode] ??
                                            'N/A',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSecondaryFixedVariant,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      );
                                    }).toList() ??
                                    [],
                              );
                            }).toList() ??
                            [],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'EGP ${product['price'] ?? 'N/A'}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 8,
                right: 8,
                child: _buildFavoriteButton(product['id'].toString()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // _buildFavoriteButton needs to be defined in this file or accessible
  Widget _buildFavoriteButton(String productId) {
    // Implement your favorite button logic here
    return Container(); // Placeholder
  }
}