// category_bottom_sheet.dart
import 'package:flutter/material.dart';

import 'shop_categories_widget.dart';

void showCategoryBottomSheet(
    BuildContext context, Map<String, dynamic> product) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.5, // Adjust this as necessary
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['categories'] != null &&
                            product['categories'].isNotEmpty &&
                            product['categories'][0]['name'] != null
                        ? product['categories'][0]['name']
                        : 'N/A',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  // Add a debug check to ensure categories are being passed correctly
                  product['categories'] != null &&
                          product['categories'].isNotEmpty
                      ? ShopCategoriesWidget(isGridView: true)
                      : Text('No categories available'),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
