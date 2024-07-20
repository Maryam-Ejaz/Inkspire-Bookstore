import 'package:Inkspire/screens/CheckOut.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../controllers/CartSController.dart';
import '../../models/CartModel.dart';
import '../../widgets/tiles/CartTile.dart';
import '../widgets/buttons/custom_elevated_button.dart';


class CartScreenn extends StatefulWidget {
  @override
  _CartScreennState createState() => _CartScreennState();
}

class _CartScreennState extends State<CartScreenn> {
  final CartSController _cartController = CartSController.instance;
  List<CartModel> _cartList = [];
  double _total = 0.0;

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    List<CartModel> cartItems = await _cartController.loadCart();
    setState(() {
      _cartList = cartItems;
      _calculateTotal();
    });
  }

  void _calculateTotal() {
    setState(() {
      _total = _cartList.fold(0, (sum, item) => sum + (item.price * item.quantity));
    });
  }

  void _toCheckOutScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckOut(orderAmount: _total),
      ),
    );
  }

  void _removeItem(int cartId) {
    _cartController.removeFromCart(cartId);
    setState(() {
      _cartList.removeWhere((item) => item.cartId == cartId);
      _calculateTotal();
    });
  }

  void _updateItemQuantity(int cartId, int newQuantity) {
    _cartController.updateItemQuantity(cartId, newQuantity);
    setState(() {
      var item = _cartList.firstWhere((item) => item.cartId == cartId);
      if (item != null) {
        item.quantity = newQuantity;
        _calculateTotal();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: kOffBlack,
            size: 20,
          ),
        ),
        centerTitle: true,
        title: const Text(
          "MY CART",
          style: kMerriweatherBold16,
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: _cartList.isEmpty
            ? const Center(child: Text("No Item present in the cart"))
            : Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: _cartList.length,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return CartTile(
                    cartItem: _cartList[index],
                    onRemove: (cartId) => _removeItem(cartId),
                    onUpdateQuantity: (cartId, newQuantity) =>
                        _updateItemQuantity(cartId, newQuantity),
                    showQuantityControls: true, // Pass true to show quantity controls
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider(
                    height: 12,
                    thickness: 1,
                    color: kSnowFlakeWhite,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Container(
                    height: 45,
                    margin: const EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x258A959E),
                          offset: Offset(0, 2),
                          blurRadius: 20,
                        )
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total",
                        style: kNunitoSansSemiBold18.copyWith(color: kGraniteGrey),
                      ),
                      Text(
                        "\$ $_total",
                        style: kNunitoSansBold20.copyWith(color: kOffBlack),
                      ),
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    height: 70,
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x258A959E),
                          offset: Offset(0, 2),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: CustomElevatedButton(
                      onTap: _toCheckOutScreen,
                      text: 'CHECK OUT',
                    ),

                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
