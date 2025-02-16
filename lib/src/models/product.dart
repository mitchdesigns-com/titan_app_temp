// // lib/src/models/product.dart
// class Product {
//   final String id;
//   final String name;
//   final String imageUrl;
//   final double price;

//   Product({
//     required this.id,
//     required this.name,
//     required this.imageUrl,
//     required this.price,
//   });

//   factory Product.fromJson(Map<String, dynamic> json) {
//     return Product(
//       id: json['id'],
//       name: json['name'],
//       imageUrl: json['image_url'],
//       price: json['price'].toDouble(),
//     );
//   }
// }
// lib/src/models/product.dart
class Product {
  final int id;
  final String slug;
  final Map<String, dynamic> name; // Assuming name is a map (localized names)
  final double price;
  final MainImage main_img;
  final List<Tag>? tags;
  // ... other fields

  Product({
    required this.id,
    required this.slug,
    required this.name,
    required this.price,
    required this.main_img,
    this.tags,
    // ... other fields
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'slug': slug,
    'name': name,
    'price': price,
    'main_img': main_img.toJson(), // Call toJson() on nested objects
    'tags': tags?.map((tag) => tag.toJson()).toList(), // Call toJson() on list of objects
    // ... other fields
  };

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json['id'],
    slug: json['slug'],
    name: json['name'],
    price: (json['price'] is int) ? json['price'].toDouble() : json['price'],
    main_img: MainImage.fromJson(json['main_img']),
    tags: (json['tags'] as List?)?.map((tag) => Tag.fromJson(tag)).toList(),
      // ... other fields
  );
}

class MainImage {
  final String src;

  MainImage({required this.src});

  Map<String, dynamic> toJson() => {
    'src': src,
  };

  factory MainImage.fromJson(Map<String, dynamic> json) =>
      MainImage(src: json['src']);
}

class Tag {
  final List<Value>? values;

  Tag({this.values});

  Map<String, dynamic> toJson() => {
    'values': values?.map((value) => value.toJson()).toList(),
  };

  factory Tag.fromJson(Map<String, dynamic> json) => Tag(
        values: (json['values'] as List?)
            ?.map((value) => Value.fromJson(value))
            .toList(),
      );
}

class Value {
  final Map<String, dynamic> name;

  Value({required this.name});

  Map<String, dynamic> toJson() => {
    'name': name,
  };

  factory Value.fromJson(Map<String, dynamic> json) => Value(
        name: json['name'],
      );
}