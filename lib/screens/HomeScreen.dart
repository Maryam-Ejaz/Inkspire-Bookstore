import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:convert';
import '../models/ProductModel.dart';
import '../widgets/tabbed/CategoryTab.dart';
import '../widgets/tiles/ProdGridTile.dart';
import 'CartScreen.dart';
import '../constants.dart';
import 'search_delegate/product_search_delegate.dart';
import '../controllers/HomePageController.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomePageController _controller = HomePageController();
  List<ProductModel> productsList = [];
  int selectedCategory = 0;

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    try {
      String jsonString = await rootBundle.loadString('assets/Products/products.json');
      List<dynamic> data = json.decode(jsonString);
      setState(() {
        productsList = data.map((json) => ProductModel.fromJson(json)).toList();
      });
    } catch (e) {
      print('Error loading products: $e');
    }
  }

  Future<void> _changeCategory(int categoryId) async {
    selectedCategory = categoryId;
    List<ProductModel> filteredProducts;
    if (categoryId == 0) {
      filteredProducts = await _controller.loadInitialProducts();
    } else {
      filteredProducts = await _controller.getProductsByCategory(categoryId);
    }
    setState(() {
      productsList = filteredProducts;
    });
  }

  void _onCartTap(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CartScreenn()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              leading: IconButton(
                onPressed: () {
                  showSearch(
                      context: context, delegate: ProductSearchDelegate());
                },
                icon: SvgPicture.asset(
                  'assets/icons/search_icon_grey.svg',
                ),
              ),
              title: Column(
                children: [
                  Text(
                    'INKSPIRE',
                    style: kGelasio18.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 29,
                      color: kOffBlack,
                    ),
                  ),
                ],
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  onPressed: () => _onCartTap(context),
                  icon: SvgPicture.asset(
                    'assets/icons/cart_icon_grey.svg',
                  ),
                )
              ],
              bottom: PreferredSize(
                  preferredSize: Size(double.infinity, 65),
                  child: CategoryTab(
                    selectedCategory: selectedCategory,
                    onCategorySelected: _changeCategory,
                  )),
              floating: true,
              snap: true,
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.55,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 18,
                ),
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    return ProdGridTile(
                      product: productsList[index],
                    );
                  },
                  childCount: productsList.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
