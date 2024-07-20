
import 'package:Inkspire/controllers/CardController.dart';

import '../models/CardModel.dart';

class AddPaymentControllerr {
  final Cardcontroller _dbHelper = Cardcontroller();

  Future<void> addCardDetail(String cardNumber) async {
    final card = CardModel(cardNumber: cardNumber);
    await _dbHelper.insertCard(card);
  }

  Future<String?> getLastFourDigits() async {
    final card = await _dbHelper.getLastCard();
    if (card != null) {
      String cardNumber = card.cardNumber;
      return cardNumber.length >= 4 ? cardNumber.substring(cardNumber.length - 4) : null;
    }
    return null;
  }
}
