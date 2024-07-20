import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import '../models/ProductModel.dart';

class HomePageController {
  Future<List<ProductModel>> loadInitialProducts() async {
    final response = await rootBundle.loadString('assets/Products/products.json');
    List<dynamic> responseList = json.decode(response);
    return responseList.map((json) => ProductModel.fromJson(json)).toList();
  }

  Future<List<ProductModel>> getProductsByCategory(int categoryId) async {
    final response = await rootBundle.loadString('assets/Products/products.json');
    List<dynamic> responseList = json.decode(response);

    return responseList
        .where((productResponse) => productResponse['categoryId'] == categoryId)
        .map((json) => ProductModel.fromJson(json))
        .toList();
  }
}
