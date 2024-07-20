import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../constants.dart';
import '../../controllers/CartSController.dart';
import '../../models/CartModel.dart';
import '../../models/ProductModel.dart';
import '../../screens/ProductDetailScreen.dart';

class ProdGridTile extends StatelessWidget {
  final ProductModel product;
  final bool heroMode;

  ProdGridTile({Key? key, required this.product, this.heroMode = true}) : super(key: key);

  void _productOnTap(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(product: product),
      ),
    );
  }

  void _addToCart(BuildContext context) async {
    CartSController cartController = CartSController.instance; // Use singleton instance

    CartModel cartItem = CartModel(
      product.productId,
      1, // Initial quantity to add to cart
      {
        'product_id': product.productId,
        'name': product.name,
        'price': product.price,
        'description': product.description,
        'categoryId': product.categoryId,
        'imagesList': product.imagesList,
      },
    );

    await cartController.addToCart(cartItem, context); // Add item to cart


  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => _productOnTap(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 0.7,
            child: Hero(
              tag: product.productId.toString(), // Ensure this is unique for each product
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      cacheKey: product.imagesList[0],
                      imageUrl: product.imagesList[0],
                      progressIndicatorBuilder: (context, url, downloadProgress) {
                        if (downloadProgress.progress == null) {
                          return const SizedBox();
                        } else {
                          return Image.asset(
                            'assets/loading.gif',
                            height: 500,
                            width: 500,
                            fit: BoxFit.cover,
                          );
                        }
                      },
                      height: 500,
                      width: 500,
                      maxHeightDiskCache: (size.height * 2).toInt(),
                      maxWidthDiskCache: (size.width * 2).toInt(),
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      right: 12,
                      bottom: 10,
                      child: GestureDetector(
                        onTap: () => _addToCart(context), // Call _addToCart on tap
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: kGraniteGrey.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: SvgPicture.asset(
                            'assets/icons/shopping_bag_icon.svg',
                            height: 20,
                            width: 20,
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            product.name,
            style: kNunitoSans14.copyWith(
              color: kGraniteGrey,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            '\$ ${product.price}.00',
            style: kNunitoSans14.copyWith(
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
