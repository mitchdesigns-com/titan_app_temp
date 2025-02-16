import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../themes/language_provider.dart';
import 'google_font_text.dart';

class ProductListWidget extends StatefulWidget {
  const ProductListWidget({super.key});

  @override
  State<ProductListWidget> createState() => _ProductListWidgetState();
}

class _ProductListWidgetState extends State<ProductListWidget> {
  List<dynamic> _products = [];
  bool _isLoading = true;
  String _errorMessage = '';
  Set<String> _favoriteProductIds = {}; // Track favorite product IDs

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final languageCode =
        Provider.of<LanguageProvider>(context, listen: false).currentLanguage;
    final url = Uri.parse(
        'https://salesucre.woosonicpwa.com/api/products/all?lang=$languageCode&conditions[in_stock]=1');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        if (decodedData is Map<String, dynamic> &&
            decodedData['status'] == 200) {
          _products = decodedData['data'] as List<dynamic>;
        } else {
          _errorMessage = 'Invalid data format from API';
        }
      } else {
        _errorMessage = 'Failed to load products: ${response.statusCode}';
      }
    } catch (e) {
      _errorMessage = 'Error loading products: $e';
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Check if the user is logged in (implement this based on your app logic)
  bool _isLoggedIn() {
    // Replace with actual login check (e.g., check if token exists)
    return true; // Example: User is not logged in
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _buildSkeletonLoader();
    } else if (_errorMessage.isNotEmpty) {
      return _buildErrorMessage(_errorMessage);
    } else {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 8, 0, 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  GoogleFontText(
                    text: "المنتجات المتاحة",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(),
              child: ClipRect(
                child: SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  child: _buildProductList(_products),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildProductList(List<dynamic> products) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: products.map((product) {
          return _buildProductCard(product);
        }).toList(),
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    final languageCode = Provider.of<LanguageProvider>(context).currentLanguage;

    return GestureDetector(
      // Wrap the card with GestureDetector
      onTap: () {
        print("the SLUG");
        print(product['slug']);
        Navigator.pushNamed(
          context,
          '/product_details',
          arguments: product['slug'], // Pass the product SLUG as argument
        );
      },
      child: Container(
        width: 186,
        height: 300,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          // Use a Stack to position the favorite button
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 186,
                  height: 186,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(product['main_img']['src'] ?? ''),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[200],
                  ),
                ),
                SizedBox(height: 8),
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
                SizedBox(height: 4),
                Expanded(
                  // Important: Wrap the ListView in an Expanded
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: ListView(
                      physics: NeverScrollableScrollPhysics(),
                      children: product['tags']?.map<Widget>((tag) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: tag['values']?.map<Widget>((value) {
                                    return GoogleFontText(
                                      text:
                                          value['name'][languageCode] ?? 'N/A',
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
              top: 8, // Adjust top padding as needed
              right: 8, // Adjust right padding as needed
              child: _buildFavoriteButton(product['id'].toString()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoriteButton(String productId) {
    bool isFavorite = _favoriteProductIds.contains(productId);

    return GestureDetector(
      // Use GestureDetector for tap events
      onTap: () {
        if (!_isLoggedIn()) {
          _showLoginDialog();
        } else {
          setState(() {
            if (isFavorite) {
              _favoriteProductIds.remove(productId);
            } else {
              _favoriteProductIds.add(productId);
            }
          });
        }
      },
      child: Container(
        width: 25,
        height: 25,
        decoration: ShapeDecoration(
          color: isFavorite
              ? Theme.of(context).colorScheme.errorContainer
              : Theme.of(context).colorScheme.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          shadows: [
            BoxShadow(
              color: Color(0x19000000),
              blurRadius: 4,
              offset: Offset(0, 2),
              spreadRadius: 0,
            )
          ],
        ),
        child: Center(
          // Center the icon
          child: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite
                ? Theme.of(context).colorScheme.surface
                : Theme.of(context).colorScheme.onSurface,
            size: 16, // Adjust icon size as needed
          ),
        ),
      ),
    );
  }

  void _showLoginDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Please log in to add favorites"),
          content:
              Text("You need to log in to add products to your favorites."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                // Navigate to the login screen or show a login prompt
              },
              child: Text("Log in"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSkeletonLoader() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(5, (index) => _buildSkeletonCard()),
      ),
    );
  }

  Widget _buildSkeletonCard() {
    return Container(
      width: 150,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: 120,
              height: 16,
              color: Theme.of(context).colorScheme.surface,
            ),
          ),
          const SizedBox(height: 4),
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: 80,
              height: 16,
              color: Theme.of(context).colorScheme.surface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorMessage(String title) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.red[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          title,
          style: TextStyle(color: Colors.red, fontSize: 16),
        ),
      ),
    );
  }
}
