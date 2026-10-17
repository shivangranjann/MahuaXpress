class ProductModel {
  final String id;
  final String name;
  final String category;
  final String subCategory;
  final String unit;
  final double price;
  final double mrp;
  final String imageUrl;
  final String description;
  final bool inStock;
  final int stockQuantity;
  final int deliveryMinutes;
  final bool isBestseller;
  final double rating;
  final int reviewCount;

  ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.subCategory,
    required this.unit,
    required this.price,
    required this.mrp,
    required this.imageUrl,
    this.description = '',
    this.inStock = true,
    this.stockQuantity = 50,
    this.deliveryMinutes = 9,
    this.isBestseller = false,
    this.rating = 4.8,
    this.reviewCount = 124,
  });

  int get discountPercentage {
    if (mrp <= price || mrp == 0) return 0;
    return (((mrp - price) / mrp) * 100).round();
  }

  double get savingsAmount {
    if (mrp <= price) return 0;
    return mrp - price;
  }

  ProductModel copyWith({
    String? id,
    String? name,
    String? category,
    String? subCategory,
    String? unit,
    double? price,
    double? mrp,
    String? imageUrl,
    String? description,
    bool? inStock,
    int? stockQuantity,
    int? deliveryMinutes,
    bool? isBestseller,
    double? rating,
    int? reviewCount,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      subCategory: subCategory ?? this.subCategory,
      unit: unit ?? this.unit,
      price: price ?? this.price,
      mrp: mrp ?? this.mrp,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      inStock: inStock ?? this.inStock,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      deliveryMinutes: deliveryMinutes ?? this.deliveryMinutes,
      isBestseller: isBestseller ?? this.isBestseller,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'subCategory': subCategory,
      'unit': unit,
      'price': price,
      'mrp': mrp,
      'imageUrl': imageUrl,
      'description': description,
      'inStock': inStock,
      'stockQuantity': stockQuantity,
      'deliveryMinutes': deliveryMinutes,
      'isBestseller': isBestseller,
      'rating': rating,
      'reviewCount': reviewCount,
    };
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      subCategory: json['subCategory'] as String? ?? 'General',
      unit: json['unit'] as String,
      price: (json['price'] as num).toDouble(),
      mrp: (json['mrp'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
      description: json['description'] as String? ?? '',
      inStock: json['inStock'] as bool? ?? true,
      stockQuantity: json['stockQuantity'] as int? ?? 50,
      deliveryMinutes: json['deliveryMinutes'] as int? ?? 9,
      isBestseller: json['isBestseller'] as bool? ?? false,
      rating: (json['rating'] as num?)?.toDouble() ?? 4.8,
      reviewCount: json['reviewCount'] as int? ?? 120,
    );
  }
}
