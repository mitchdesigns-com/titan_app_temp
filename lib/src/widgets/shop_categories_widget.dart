import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../themes/language_provider.dart';
import 'category_tile.dart';
import 'google_font_text.dart';

class ShopCategoriesWidget extends StatefulWidget {
  final bool isGridView; // Add a parameter to the constructor

  const ShopCategoriesWidget(
      {super.key, this.isGridView = false}); // Default to ListView

  @override
  State<ShopCategoriesWidget> createState() => _ShopCategoriesWidgetState();
}

class _ShopCategoriesWidgetState extends State<ShopCategoriesWidget> {
  List<dynamic> _categories = [];
  bool _isLoading = true;
  bool _isListView = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _isListView = !widget.isGridView;
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final languageCode =
        Provider.of<LanguageProvider>(context, listen: false).currentLanguage;
    final url = Uri.parse(
        'https://salesucre.woosonicpwa.com/api/shopCategories/all?lang=$languageCode');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        if (decodedData is Map<String, dynamic> &&
            decodedData['status'] == 200) {
          _categories = decodedData['data'] as List<dynamic>;
        } else {
          _errorMessage = 'Invalid data format from API';
        }
      } else {
        _errorMessage = 'Failed to load categories: ${response.statusCode}';
      }
    } catch (e) {
      _errorMessage = 'Error loading categories: $e';
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _buildProductShimmer();
    } else if (_errorMessage.isNotEmpty) {
      return _buildErrorMessage();
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                GoogleFontText(
                  text: "الاقسام",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          _isListView
              ? ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 200),
                  child: SizedBox(
                    height: 200,
                    child: _buildCategoryList(_categories),
                  ),
                )
              : Expanded(
                  child: _buildCategoryGrid(_categories, context),
                ),
        ],
      );
    }
  }

  Widget _buildCategoryList(List<dynamic> categories) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        print('category DATA');
        print(category);
        return CategoryTile(
          categoryName: category['name'] ?? 'N/A',
          categorySlug: category['slug'] ?? 'N/A',
          imageUrl: category['image']['src'] ?? 'assets/images/categories/${index}.png',
        );
      },
    );
  }

  Widget _buildCategoryGrid(List<dynamic> categories, BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    int crossAxisCount = 2;
    double ratio = screenWidth / (screenHeight * 0.5);

    return GridView.count(
      crossAxisCount: crossAxisCount,
      childAspectRatio: ratio,
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.all(8.0),
      children: List.generate(categories.length, (index) {
        final category = categories[index];
        print('category DATA');
        print(category);
        return CategoryTile(
          categoryName: category['name'] ?? 'N/A',
          categorySlug: category['slug'] ?? 'N/A',
          imageUrl: 'assets/images/categories/${index}.png',
        );
      }),
    );
  }

  Widget _buildProductShimmer() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(5, (index) => _buildShimmerCard()),
      ),
    );
  }

  Widget _buildShimmerCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: 150,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(width: 150, height: 150, color: Colors.white),
            SizedBox(height: 8),
            Container(width: 100, height: 15, color: Colors.white),
            SizedBox(height: 4),
            Container(width: 80, height: 15, color: Colors.white),
            SizedBox(height: 4),
            Container(width: 60, height: 20, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red.shade200),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 50),
            SizedBox(height: 10),
            Text(
              "حدث خطأ أثناء تحميل الأقسام!",
              style: TextStyle(
                color: Colors.red.shade900,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            Text(
              _errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.red.shade700,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _retryLoading,
              icon: Icon(Icons.refresh),
              label: Text("إعادة المحاولة"),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _retryLoading() {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    _loadCategories();
  }
}
