import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../constants.dart';
import '../../models/ProductModel.dart';
import '../../widgets/tiles/ProdGridTile.dart';

class ProductSearchDelegate extends SearchDelegate {
  // Method to read products from a JSON file
  Future<List<ProductModel>> _loadProducts() async {
    final String response = await rootBundle.loadString('assets/Products/products.json');
    final List<dynamic> data = json.decode(response);
    return data.map((json) => ProductModel.fromJson(json)).toList();
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          onPressed: () {
            query = "";
          },
          icon: const Icon(Icons.clear),
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.pop(context);  // Replaced Get.back() with Navigator.pop(context)
      },
      icon: const Icon(Icons.arrow_back_ios),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<ProductModel>>(
      future: _loadProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            List<ProductModel> productList = snapshot.data!.where((product) {
              return product.name.toLowerCase().contains(query.toLowerCase());
            }).toList();

            if (productList.isEmpty) {
              return Center(
                child: Text(
                  "No Matching Products Found 🥺",
                  style: kNunitoSans16.copyWith(
                    color: kGrey,
                  ),
                ),
              );
            } else {
              return GridView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
                itemCount: productList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.55,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 18,
                ),
                itemBuilder: (context, index) {
                  return ProdGridTile(
                    product: productList[index],
                    heroMode: false,
                  );
                },
              );
            }
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error loading products",
                style: kNunitoSans16.copyWith(
                  color: kGrey,
                ),
              ),
            );
          }
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: kOffBlack,
            ),
          );
        }
        return const SizedBox();
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const SizedBox();
  }
}
