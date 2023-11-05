class CardModel {
  final String numb;
  final DateTime orderDate;
  final DateTime dueDate;
  final int quantity;
  final int subtotal;
  final String trackingNumber;
  final String kingOfOrder;
  CardModel(
      {required this.quantity,
      required this.subtotal,
      required this.trackingNumber,
      required this.numb,
      required this.orderDate,
      required this.kingOfOrder,
      required this.dueDate});
}
