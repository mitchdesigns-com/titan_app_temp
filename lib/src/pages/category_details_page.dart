import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import Provider
import '../services/api_service.dart'; // Import ApiService
import '../models/product.dart'; // Import Product Model
import '../themes/language_provider.dart';
import '../widgets/product_card.dart';
// import '../widgets/product_card.dart';

class CategoryDetailsPage extends StatefulWidget {
  const CategoryDetailsPage({super.key});

  @override
  State<CategoryDetailsPage> createState() => _CategoryDetailsPageState();
}

class _CategoryDetailsPageState extends State<CategoryDetailsPage> {
  late Future<List<Product>> _productsFuture;
  final ApiService _apiService = ApiService();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final categorySlug = ModalRoute.of(context)!.settings.arguments as String;
    final languageCode = Provider.of<LanguageProvider>(context, listen: false)
        .currentLanguage; // Get language code from Provider
    _productsFuture = _apiService.fetchProducts(
        categorySlug: categorySlug,
        lang: languageCode); // Pass categorySlug to API call
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Category Details'),
      ),
      body: FutureBuilder<List<Product>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final products = snapshot.data!;
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final productMap = products[index].toJson(); // Use your toJson() method

                return ProductCard(product: productMap); // Pass the map
              },
            );
          } else {
            return const Center(child: Text('No products found.'));
          }
        },
      ),
    );
  }
}
