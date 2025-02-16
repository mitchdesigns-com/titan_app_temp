import 'package:flutter/material.dart';

import '../widgets/image_banner.dart';
import '../widgets/menu_widget.dart';
import '../widgets/product_grid.dart';
import '../widgets/shop_categories_widget.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(// Wrap with Builder
        builder: (BuildContext scaffoldContext) {
      // Give it a name (scaffoldContext)
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: const Text('Home'),
        ),
        drawer: const MenuWidget(),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                ImageRowWidget(
                  imageUrls: [
                    'assets/images/banner/1.png',
                    'assets/images/banner/2.png',
                    'assets/images/banner/3.png',
                  ],
                  widths: [280, 280, 388],
                ),
                ShopCategoriesWidget(),
                SizedBox(height: 20),
                Divider(
                  thickness: 12,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
                SizedBox(height: 20),
                ProductListWidget(),
              ],
            ),
          ),
        ),
      );
    });
  }
}
