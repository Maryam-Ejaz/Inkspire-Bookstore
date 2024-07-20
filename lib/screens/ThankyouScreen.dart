import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../constants.dart';
import '../../widgets/buttons/custom_elevated_button.dart';


class ThankYouScreen extends StatelessWidget {
  const ThankYouScreen({super.key});

  void _navigateToHome(BuildContext context) {
    Navigator.popUntil(context, ModalRoute.withName('/'));
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Customize your back button behavior here
        return Future.value(false);
      },
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),
                Text(
                  "SUCCESS!",
                  style: kMerriweatherBold16.copyWith(
                    fontSize: 36,
                    letterSpacing: 1.5,
                  ),
                ),
                SizedBox(
                  height: 280,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset("assets/success.png", height: 280),
                      Positioned(
                        bottom: 0,
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: const BoxDecoration(
                            color: kCrayolaGreen,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  "Your order will be delivered soon.\nThank you for choosing our app!",
                  style: kNunitoSans18.copyWith(
                    color: kGraniteGrey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                SizedBox(
                  height: 60,
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => _navigateToHome(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: kOffBlack,
                      side: const BorderSide(color: kOffBlack),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "BACK TO HOME",
                      style: kNunitoSansSemiBold18,
                    ),
                  ),
                ),
                const Spacer(flex: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
