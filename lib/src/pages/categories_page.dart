import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/shop_categories_widget.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text('Home'),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Text(
              "الاقسام",
              style: GoogleFonts.vazirmatn(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
            Expanded(
              child: ShopCategoriesWidget(isGridView: true),
            ),
          ],
        ),
      ),
    );
  }
}
