import 'package:Inkspire/screens/ThankyouScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../constants.dart';
import '../../controllers/CartSController.dart';
import '../../models/CartModel.dart';
import '../../widgets/tiles/CartTile.dart';
import '../controllers/AddPaymentController.dart';
import '../widgets/buttons/custom_elevated_button.dart';
import 'AddPayment.dart';

class CheckOut extends StatefulWidget {
  final double orderAmount;
  const CheckOut({super.key, required this.orderAmount});

  @override
  _CheckOutState createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  final CartSController _cartController = CartSController.instance;
  final AddPaymentControllerr _paymentController = AddPaymentControllerr();
  TextEditingController _addressController = TextEditingController();
  List<CartModel> _cartList = [];
  String _lastFourDigits = "XXXX"; // Default value

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    List<CartModel> cartItems = await _cartController.loadCart();
    setState(() {
      _cartList = cartItems;
    });
  }

  Future<void> _loadLastFourDigits() async {
    String? lastFour = await _paymentController.getLastFourDigits();
    setState(() {
      _lastFourDigits = lastFour ?? "XXXX"; // Update state with retrieved value
    });
  }

  void _removeItem(int cartId) {
    _cartController.removeFromCart(cartId);
    setState(() {
      _cartList.removeWhere((item) => item.cartId == cartId);
    });
  }

  void _updateItemQuantity(int cartId, int newQuantity) {
    _cartController.updateItemQuantity(cartId, newQuantity);
    setState(() {
      var item = _cartList.firstWhere((item) => item.cartId == cartId);
      if (item != null) {
        item.quantity = newQuantity;
      }
    });
  }

  void _onCheckOut() {
    if (_addressController.text.isEmpty) {
      _showErrorDialog("Please fill in your shipping address.");
      return;
    }

    if (_lastFourDigits == "XXXX") {
      _showErrorDialog("Please add your payment details.");
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ThankYouScreen()),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _toPaymentScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddPayment()),
    );
  }

  @override
  Widget build(BuildContext context) {
    double totalAmount = widget.orderAmount + 5;
    _loadLastFourDigits();

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
          "CHECK OUT",
          style: kMerriweatherBold16,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Shipping Address",
                  style: kNunitoSansSemiBold18.copyWith(
                    color: kTinGrey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Placeholder for shipping address
            Container(
              height: 69,
              width: double.infinity,
              margin: const EdgeInsets.only(top: 10, bottom: 20),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x408A959E),
                    offset: Offset(0, 8),
                    blurRadius: 40,
                  )
                ],
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  hintText: 'Enter your shipping address',
                  border: InputBorder.none,
                  hintStyle: kNunitoSans14.copyWith(color: kGraniteGrey),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Payment",
                  style: kNunitoSansSemiBold18.copyWith(
                    color: kTinGrey,
                  ),
                ),
                IconButton(
                  onPressed: _toPaymentScreen,
                  icon: SvgPicture.asset("assets/icons/edit_icon.svg"),
                ),
              ],
            ),
            // Placeholder for payment method
            Container(
              height: 69,
              width: double.infinity,
              margin: const EdgeInsets.only(top: 10, bottom: 20),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x408A959E),
                    offset: Offset(0, 8),
                    blurRadius: 40,
                  )
                ],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    height: 38,
                    width: 64,
                    margin: const EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x20000000),
                          offset: Offset(0, 1),
                          blurRadius: 25,
                        )
                      ],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SvgPicture.asset(
                      'assets/icons/mastercard_bw.svg',
                      height: 25,
                      width: 32,
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                  Text(
                    "**** **** **** $_lastFourDigits",
                    style: kNunitoSans14.copyWith(
                      fontWeight: FontWeight.w600,
                      color: kRaisinBlack,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Delivery method",
                  style: kNunitoSansSemiBold18.copyWith(
                    color: kTinGrey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Placeholder for delivery method
            Container(
              height: 54,
              width: double.infinity,
              margin: const EdgeInsets.only(top: 10, bottom: 20),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x408A959E),
                    offset: Offset(0, 8),
                    blurRadius: 40,
                  )
                ],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Image.asset("assets/pakpost.png"),
                  const SizedBox(width: 15),
                  Text(
                    "Fast (2-3 days)",
                    style: kNunitoSans14.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Order Summary",
              style: kNunitoSansSemiBold18.copyWith(
                color: kTinGrey,
              ),
            ),
            const SizedBox(height: 18),
            Container(
              height: MediaQuery.of(context).size.height * 0.1, // Adjust this value as needed
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
                    showQuantityControls: false, // Pass true to show quantity controls
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
            const Spacer(),
            Container(
              height: 135,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x408A959E),
                    offset: Offset(0, 8),
                    blurRadius: 40,
                  )
                ],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Order:",
                        style: kNunitoSansTinGrey18,
                      ),
                      Text(
                        "\$ ${widget.orderAmount}",
                        style: kNunitoSansSemiBold18,
                      ),
                    ],
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Delivery:",
                        style: kNunitoSansTinGrey18,
                      ),
                      Text(
                        "\$ 5.00",
                        style: kNunitoSansSemiBold18,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total:",
                        style: kNunitoSansTinGrey18,
                      ),
                      Text(
                        "\$ $totalAmount",
                        style: kNunitoSansSemiBold18,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            CustomElevatedButton(
                onTap: _onCheckOut,
                text: 'CHECK OUT',
              ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
