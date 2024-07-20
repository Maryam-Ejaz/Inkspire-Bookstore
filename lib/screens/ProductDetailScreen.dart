import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../constants.dart';
import '../../models/ProductModel.dart';
import '../../widgets/animation/fade_in_widget.dart';
import '../../widgets/buttons/custom_elevated_button.dart';
import '../controllers/CartSController.dart';
import '../models/CartModel.dart';
import '../widgets/tabbed/ProdImageView.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel product;

  ProductDetailScreen({Key? key, required this.product}) : super(key: key);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  void _addToCart() async {
    CartSController cartController = CartSController.instance; // Use singleton instance

    CartModel cartItem = CartModel(
      widget.product.productId, // Use widget.product here
      _quantity, // Use selected quantity
      {
        'product_id': widget.product.productId, // Use widget.product here
        'name': widget.product.name, // Use widget.product here
        'price': widget.product.price, // Use widget.product here
        'description': widget.product.description, // Use widget.product here
        'categoryId': widget.product.categoryId, // Use widget.product here
        'imagesList': jsonEncode(widget.product.imagesList), // Use widget.product here
      },
    );

    await cartController.addToCart(cartItem, context); // Add item to cart with context
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Stack(
              children: [
                ProdImageView(imagesList: widget.product.imagesList), // Use widget.product here
                Positioned(
                  left: 27,
                  top: size.height * 0.05,
                  child: FadeInWidget(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          color: kOffBlack,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.product.name, // Use widget.product here
                  style: kGelasio18.copyWith(
                    fontSize: 24,
                    color: kOffBlack,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$ ${widget.product.price}', // Use widget.product here
                      style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: kOffBlack),
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: _incrementQuantity,
                          child: Container(
                            height: 30,
                            width: 30,
                            margin: const EdgeInsets.only(right: 15),
                            decoration: BoxDecoration(
                              color: kChristmasSilver,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.add,
                              color: kTinGrey,
                            ),
                          ),
                        ),
                        Text(
                          '$_quantity',
                          style: kNunitoSansSemiBold18,
                        ),
                        GestureDetector(
                          onTap: _decrementQuantity,
                          child: Container(
                            height: 30,
                            width: 30,
                            margin: const EdgeInsets.only(left: 15),
                            decoration: BoxDecoration(
                              color: kChristmasSilver,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.remove,
                              color: kTinGrey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  // onTap: _toProductReviewScreen,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/star_icon.svg',
                        height: 20,
                        width: 20,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        '4.5',
                        style: kNunitoSansSemiBold18,
                      ),
                      const SizedBox(width: 10),
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          '(50 reviews)',
                          style: kNunitoSans14.copyWith(
                            fontWeight: FontWeight.w600,
                            color: kGrey,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.product.description, // Use widget.product here
                  style: kNunitoSans14.copyWith(
                    fontWeight: FontWeight.w300,
                    color: kGraniteGrey,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 20),
                    Expanded(
                      child: CustomElevatedButton(
                        onTap: _addToCart,
                        text: "Add to cart",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
