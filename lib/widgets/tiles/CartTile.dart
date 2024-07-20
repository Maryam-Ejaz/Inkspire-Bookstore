import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../constants.dart';
import '../../models/CartModel.dart';

class CartTile extends StatelessWidget {
  final CartModel cartItem;
  final Function(int) onRemove;
  final Function(int, int) onUpdateQuantity;
  final bool showQuantityControls; // New parameter to control visibility of quantity controls

  CartTile({
    super.key,
    required this.cartItem,
    required this.onRemove,
    required this.onUpdateQuantity,
    this.showQuantityControls = true, // Default to true if not specified
  });

  void _productOnTap(BuildContext context) {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => ProductDetailScreen(product: product),
    //   ),
    // );
  }

  void _removeFromCart() {
    onRemove(cartItem.cartId);
  }

  void _incrementQuantity() {
    onUpdateQuantity(cartItem.cartId, cartItem.quantity + 1);
  }

  void _decrementQuantity() {
    if (cartItem.quantity > 1) {
      onUpdateQuantity(cartItem.cartId, cartItem.quantity - 1);
    } else {
      _removeFromCart();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: showQuantityControls ? 100 : 60, // Adjust height based on visibility of quantity controls
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => _productOnTap(context),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Hero(
                tag: cartItem.imagesList[0],
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    cacheKey: cartItem.imagesList[0],
                    imageUrl: cartItem.imagesList[0],
                    placeholder: (context, url) {
                      return Image.asset(
                        'assets/loading.gif',
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      );
                    },
                    height: showQuantityControls ? 100 : 60, // Adjust image size based on visibility of quantity controls
                    width: showQuantityControls ? 100 : 60,
                    maxHeightDiskCache: (size.height * 2).toInt(),
                    maxWidthDiskCache: (size.width * 2).toInt(),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (showQuantityControls) // Display name if controls are visible
                      Text(
                        cartItem.name,
                        style: kNunitoSans14.copyWith(
                          color: kGraniteGrey,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    else // Display "Quantity x CartTile" if controls are not visible
                      Expanded(
                        child: Text(
                          "${cartItem.quantity} x ${cartItem.name}",
                          style: kNunitoSans14.copyWith(
                            color: kGraniteGrey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    if (showQuantityControls) // Show remove button only if controls are visible
                      InkWell(
                        onTap: _removeFromCart,
                        customBorder: const CircleBorder(),
                        child: const Icon(
                          Icons.highlight_off,
                          size: 20,
                          color: kNoghreiSilver,
                        ),
                      ),
                  ],
                ),
                if (showQuantityControls) // Show quantity controls only if visible
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
                        "${cartItem.quantity}",
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
                      const Spacer(),
                      Text(
                        '\$ ${cartItem.price}',
                        style: kNunitoSansBold16,
                      ),
                    ],
                  ),
                if (!showQuantityControls) // Display total price if controls are hidden
                  Row(
                    children: [
                      const Spacer(),
                      Text(
                        '\$ ${cartItem.price * cartItem.quantity}',
                        style: kNunitoSansBold16,
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
