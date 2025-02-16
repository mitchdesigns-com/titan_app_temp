import 'package:http/http.dart' as http;
import '../env.dart'; // Import the env file

// Add a new function to fetch products
Future<List<Product>> fetchProducts() async {
  final response = await http.get(Uri.parse('${Env.apiUrl}/products'));

  if (response.statusCode == 200) {
    // Parse the JSON response
    return parseProducts(response.body);
  } else {
    throw Exception('Failed to load products');
  }
}

// Existing code...
            onPressed: () {
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
// ... 