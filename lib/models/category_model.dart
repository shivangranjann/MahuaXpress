import 'package:flutter/material.dart';

class CategoryModel {
  final String id;
  final String name;
  final String iconEmoji;
  final List<String> subCategories;
  final Color backgroundColor;

  CategoryModel({
    required this.id,
    required this.name,
    required this.iconEmoji,
    required this.subCategories,
    this.backgroundColor = const Color(0xFFF0FDF4),
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'iconEmoji': iconEmoji,
      'subCategories': subCategories,
    };
  }

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      iconEmoji: json['iconEmoji'] as String,
      subCategories: List<String>.from(json['subCategories'] as List),
    );
  }
}
