import 'package:flutter/material.dart';

class ImageRowWidget extends StatelessWidget {
  final List<String> imageUrls;
  final List<double> widths;

  const ImageRowWidget({
    super.key,
    required this.imageUrls,
    required this.widths,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 200),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 10.94),
            child: Container(
              width: widths[index],
              height: 164,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.75),
              ),
              child: imageUrls[index].startsWith('assets/')
                  ? Image.asset(
                      imageUrls[index],
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      imageUrls[index],
                      fit: BoxFit.cover,
                    ),
            ),
          );
        },
      ),
    );
  }
}
