import 'package:Inkspire/controllers/AddPaymentController.dart';
import 'package:flutter/material.dart';
import '../widgets/buttons/custom_elevated_button.dart';
import '../widgets/cards/payment_card_view.dart';
import '../widgets/input/custom_input_box.dart';


class AddPayment extends StatefulWidget {
  const AddPayment({super.key});

  @override
  _AddPaymentState createState() => _AddPaymentState();
}

class _AddPaymentState extends State<AddPayment> {
  final _formKey = GlobalKey<FormState>();
  final _controller = AddPaymentControllerr();
  String _cardNumber = "";
  String _name = "";
  String _cvv = "";
  String _expiryDate = "";
  String? _lastFourDigits = "XXXX";

  void _addCard() async {
    if (_formKey.currentState?.validate() ?? false) {
      await _controller.addCardDetail(_cardNumber);

      // Fetch last four digits and update state
      final lastFour = await _controller.getLastFourDigits();

      // Show snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment method added successfully'),
          duration: Duration(seconds: 2),
        ),
      );

      Navigator.pop(context, lastFour);
    }
  }

  void _nameOnChanged(String val) {
    setState(() {
      _name = val;
    });
  }

  void _cardNumberOnChanged(String val) {
    setState(() {
      _cardNumber = val.replaceAll(" ", "");
      _lastFourDigits = _cardNumber.length >= 4 ? _cardNumber.substring(_cardNumber.length - 4) : "XXXX";
    });
  }

  void _cvvOnChanged(String val) {
    setState(() {
      _cvv = val;
    });
  }

  void _expiryDateOnChanged(String val) {
    setState(() {
      _expiryDate = val;
    });
  }

  String? _nameValidator(String? val) {
    return (val?.isNotEmpty ?? false) ? null : "Enter a name";
  }

  String? _cardNumberValidator(String? val) {
    return (val != null && val.length == 20) ? null : "Enter a Valid Credit Card Number";
  }

  String? _cvvValidator(String? val) {
    return (val != null && val.length == 3) ? null : "Enter CVV";
  }

  String? _dateValidator(String? val) {
    return (val != null && val.length == 5) ? null : "Enter a Valid Date";
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
            color: Colors.black,
            size: 20,
          ),
        ),
        centerTitle: true,
        title: const Text(
          "CARD DETAIL",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                PaymentCardView(
                  cardHolderName: _name.isEmpty ? "XXXXXX" : _name,
                  expiryDateString: _expiryDate.isEmpty ? "XX/XX" : _expiryDate,
                  lastFourDigits: _lastFourDigits ?? "XXXX",
                ),
                const SizedBox(height: 30),
                CustomInputBox(
                  headerText: "Cardholder Name",
                  hintText: "Ex: Maryam",
                  textInputType: TextInputType.name,
                  onChanged: _nameOnChanged,
                  validator: _nameValidator,
                ),
                CustomInputBox(
                  headerText: "Card Number",
                  hintText: "Ex: XXXX XXXX XXXX 3456",
                  textInputType: TextInputType.number,
                  maxLength: 20,
                  inputFormatters: [CreditCardFormatter()],
                  onChanged: _cardNumberOnChanged,
                  validator: _cardNumberValidator,
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomInputBox(
                        headerText: "CVV",
                        hintText: "Ex: 123",
                        maxLength: 3,
                        obscureText: true,
                        onChanged: _cvvOnChanged,
                        validator: _cvvValidator,
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: CustomInputBox(
                        headerText: "Expiration Date",
                        hintText: "Ex: 04/22",
                        maxLength: 5,
                        textInputAction: TextInputAction.done,
                        inputFormatters: [DateFormatter()],
                        onChanged: _expiryDateOnChanged,
                        validator: _dateValidator,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                CustomElevatedButton(
                  onTap: _addCard,
                  text: "ADD NEW CARD",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
