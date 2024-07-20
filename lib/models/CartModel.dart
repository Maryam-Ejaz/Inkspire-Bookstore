import 'dart:convert';
import 'ProductModel.dart';

class CartModel extends ProductModel {
  int cartId;
  int quantity;

  CartModel(
      this.cartId,
      this.quantity,
      Map<String, dynamic> json,
      ) : super(
    json['product_id'],
    json['name'],
    json['price'],
    json['description'],
    json['categoryId'],
    (json['imagesList'] is String)
        ? List<String>.from(jsonDecode(json['imagesList'])) // Decode JSON string to List<String>
        : List<String>.from(json['imagesList']), // Handle already decoded list
  );

  void addQuantity(int newQuantity) {
    quantity += newQuantity;
  }

  void removeQuantity(int newQuantity) {
    quantity -= newQuantity;
  }

  ProductModel getProduct() {
    return super.productElement();
  }

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      json['cartId'],
      json['quantity'],
      json,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cartId': cartId,
      'quantity': quantity,
      'product_id': productId,
      'name': name,
      'price': price,
      'description': description,
      'categoryId': categoryId,
      'imagesList': jsonEncode(imagesList), // Encode List<String> to JSON string
    };
  }
}
