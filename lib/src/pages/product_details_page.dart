import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../themes/language_provider.dart';
import '../widgets/category_bottom_sheet.dart';
import '../widgets/google_font_text.dart'; // Make sure this path is correct

class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({super.key});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  Map<String, dynamic> product = {};
  bool isLoading = true;
  String errorMessage = '';
  String? languageCode; // Store the language code here

  @override
  void initState() {
    super.initState();
    // Get the language code in initState, AFTER the widget is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      languageCode =
          Provider.of<LanguageProvider>(context, listen: false).currentLanguage;
      _fetchProductDetails(); // Call API after getting language code
    });
  }

  Future<void> _fetchProductDetails() async {
    final String slug = ModalRoute.of(context)!.settings.arguments as String;

    try {
      final response = await http.get(
        Uri.parse(
            'https://salesucre.woosonicpwa.com/api/products/$slug?lang=$languageCode'),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['data'] != null) {
          setState(() {
            product = responseData['data'];
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = 'Invalid API Response';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage =
              'Failed to load product details. Status Code: ${response.statusCode}';
          isLoading = false;
        });
        print(errorMessage);
      }
    } catch (error) {
      setState(() {
        errorMessage = 'An error occurred: $error';
        isLoading = false;
      });
      print(errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Now you can safely use languageCode here, it will be initialized
    // Check if languageCode is null to prevent errors
    if (languageCode == null) {
      return const Center(
          child: CircularProgressIndicator()); // Or a placeholder
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          product['name'] != null && product['name'][languageCode] != null
              ? product['name'][languageCode]
              : 'Loading...',
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: product.isEmpty
                      ? const Center(child: Text("No product data available."))
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                showCategoryBottomSheet(context, product);
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8), // Adjust padding
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      8.0), // Rounded corners for button
                                ),
                                textStyle: TextStyle(
                                    fontSize: 21,
                                    fontWeight:
                                        FontWeight.w700), // Style for text
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize
                                    .min, // Important: Use MainAxisSize.min
                                children: [
                                  GoogleFontText(
                                    text: product['categories'] != null &&
                                            product['categories'][0]['name'] !=
                                                null
                                        ? product['categories'][0]['name']
                                        : 'N/A',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                    ),
                                  ),
                                  const SizedBox(
                                      width: 8), // Space between text and arrow
                                  const Icon(Icons
                                      .arrow_drop_down), // Add the dropdown arrow icon
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            buildImageCarousel(),
                            const SizedBox(height: 16),
                            GoogleFontText(
                              text: product['name'] != null &&
                                      product['name'][languageCode] != null
                                  ? product['name'][languageCode]
                                  : 'N/A',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: 21,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                ),
    );
  }

  int _current = 0;
  Widget buildImageCarousel() {
    List<dynamic> gallery = product['gallery'] ?? [];

    if (gallery.isEmpty) {
      return const Center(child: Text("No images available."));
    }

    return Stack(
      children: [
        CarouselSlider.builder(
          itemCount: gallery.length,
          itemBuilder: (BuildContext context, int index, int realIndex) {
            return ClipRRect(
              // Add ClipRRect for rounded corners
              borderRadius:
                  BorderRadius.circular(12.0), // Adjust the radius as needed
              child: Image.network(
                gallery[index]['src'] ?? '',
                fit: BoxFit.cover,
                errorBuilder: (context, object, stackTrace) {
                  return const Center(child: Icon(Icons.error));
                },
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
            );
          },
          options: CarouselOptions(
            autoPlay: false,
            enlargeCenterPage: true,
            aspectRatio: 1.0,
            viewportFraction: 1.0,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
          ),
        ),
        Positioned(
          bottom: 16.0,
          left: 0.0,
          right: 0.0,
          child: _buildIndicator(gallery.length),
        ),
      ],
    );
  }

  Widget _buildIndicator(int itemCount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(itemCount, (index) {
        return Container(
          width: 8.0,
          height: 8.0,
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _current == index
                ? const Color(0xFF1D2128)
                : const Color(0xFFB4B4B4), // Active/Inactive color
          ),
        );
      }),
    );
  }
}
