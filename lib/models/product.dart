class Product {
  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.tagline,
    required this.description,
    required this.price,
    required this.currency,
    required this.image,
    required this.specs,
    this.featured = false,
  });

  final int id;
  final String name, category, tagline, description, currency, image;
  final double price;
  final Map<String, String> specs;
  final bool featured;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json['id'] as int,
    name: json['name'] as String,
    category: json['category'] as String,
    tagline: json['tagline'] as String,
    description: json['description'] as String,
    price: (json['price'] as num).toDouble(),
    currency: json['currency'] as String,
    image: json['image'] as String,
    specs: Map<String, String>.from(json['specs'] as Map),
    featured: json['featured'] as bool? ?? false,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'category': category,
    'tagline': tagline,
    'description': description,
    'price': price,
    'currency': currency,
    'image': image,
    'specs': specs,
    'featured': featured,
  };
}
