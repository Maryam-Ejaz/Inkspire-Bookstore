class CardModel {
  final int? id;
  final String cardNumber;

  CardModel({this.id, required this.cardNumber});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'card_number': cardNumber,
    };
  }

  factory CardModel.fromMap(Map<String, dynamic> map) {
    return CardModel(
      id: map['id'],
      cardNumber: map['card_number'],
    );
  }
}
