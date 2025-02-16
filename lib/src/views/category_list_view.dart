// lib/src/views/category_list_view.dart
import 'package:flutter/material.dart';
import '../models/category.dart';
import '../services/api_service.dart';
import 'package:flutter_html/flutter_html.dart';

class CategoryListView extends StatefulWidget {
  static const routeName = '/categories';

  const CategoryListView({super.key});

  @override
  CategoryListViewState createState() => CategoryListViewState();
}

class CategoryListViewState extends State<CategoryListView> {
  late Future<List<Category>> _futureCategories;

  @override
  void initState() {
    super.initState();
    _futureCategories = ApiService().fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Categories')),
      body: FutureBuilder<List<Category>>(
        future: _futureCategories,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Log the error for debugging
            print('Error fetching categories: ${snapshot.error}');
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No categories found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final category = snapshot.data![index];
                return ListTile(
                  leading: Image.network(
                    category.imageUrl,
                    errorBuilder: (context, error, stackTrace) {
                      // Handle image loading errors
                      return Icon(Icons.error);
                    },
                  ),
                  title: Text(category.name),
                  subtitle: Html(
                    data: category.description,  // Render HTML from the description
                  ),
                  onTap: () {
                    // Navigate to the product list for the selected category
                    Navigator.pushNamed(context, '/productList');
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}