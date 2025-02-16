// category_tree_widget.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CategoryTreeWidget extends StatefulWidget {
  const CategoryTreeWidget({super.key});

  @override
  State<CategoryTreeWidget> createState() => _CategoryTreeWidgetState();
}

class _CategoryTreeWidgetState extends State<CategoryTreeWidget> {
  List<dynamic> _categories = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final url = Uri.parse(
        'https://salesucre.woosonicpwa.com/api/shopCategories/tree?lang=en');

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
      return const Center(child: CircularProgressIndicator());
    } else if (_errorMessage.isNotEmpty) {
      return Center(child: Text(_errorMessage));
    } else {
      return _buildCategoryTree(_categories);
    }
  }

  Widget _buildCategoryTree(List<dynamic> categories) {
    bool isExpanded = false;
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final children = category['children'];

        if (children != null &&
            children is List<dynamic> &&
            children.isNotEmpty) {
          return ExpansionTile(
            title: Text("${category['name'] ?? 'N/A'}"),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            tilePadding: const EdgeInsets.all(10),
            backgroundColor:
                isExpanded ? Colors.black12 : Colors.white,
            onExpansionChanged: (bool expanded) {
              setState(() {
                isExpanded = expanded;
              });
            },
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
                child: ListTile(
                  title: const Text("Shop All"),
                  onTap: () {
                    print("Tapped on Shop All for ${category['name']}");
                  },
                ),
              ),
              ...children
                  .map<Widget>((child) => _buildSubCategoryTree(child))
                  .toList(),
            ],
          );
        } else {
          return ListTile(
            title: Text(category['name'] ?? 'N/A'),
            onTap: () {
              print("Tapped on category without children: ${category['name']}");
            },
          );
        }
      },
    );
  }

  Widget _buildSubCategoryTree(dynamic category) {
    final children = category['children'];

    if (children != null && children is List<dynamic> && children.isNotEmpty) {
      return ExpansionTile(
        title: Text(category['name'] ?? 'N/A'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        children: children
            .map<Widget>((child) => _buildSubCategoryTree(child))
            .toList(),
      );
    } else {
      return Padding(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(category['name'] ?? 'N/A'),
          onTap: () {
            print(
                "Tapped on subcategory without children: ${category['name']}");
          },
        ),
      );
    }
  }
}
