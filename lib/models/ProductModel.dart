import 'package:flutter/material.dart';

class ProductModel {
  final int productId;
  final String name;
  final int price;
  final String description;
  final int categoryId;
  final List<String> imagesList;

  ProductModel(this.productId, this.name, this.price, this.description,
      this.categoryId, this.imagesList);

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      json['product_id'],
      json['name'],
      json['price'],
      json['description'],
      json['categoryId'],
      json['imagesList'].cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'name': name,
      'price': price,
      'description': description,
      'categoryId': categoryId,
      'imagesList': imagesList,
    };
  }
  ProductModel productElement() {
    return this;
  }
}
