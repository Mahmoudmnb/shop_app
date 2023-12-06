class OrderModel {
  final int id;
  final String email;
  final String ordersIds;
  final double totalPrice;
  final String createdAt;
  final String deliveryAddress;
  final String shoppingMethod;
  final String orderId;
  final String latitude;
  final String longitude;
  final String trackingNumber;

  OrderModel(
      {required this.id,
      required this.email,
      required this.ordersIds,
      required this.totalPrice,
      required this.createdAt,
      required this.deliveryAddress,
      required this.shoppingMethod,
      required this.orderId,
      required this.latitude,
      required this.longitude,
      required this.trackingNumber});

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
        id: map['id'],
        email: map['email'],
        ordersIds: map['ordersIds'],
        totalPrice: map['totalPrice'],
        createdAt: map['createdAt'],
        deliveryAddress: map['deliveryAddress'],
        shoppingMethod: map['shoppingMethod'],
        orderId: map['orderId'],
        latitude: map['latitude'],
        longitude: map['longitude'],
        trackingNumber: map['trackingNumber']);
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'ordersIds': orderId,
      'totalPrice': totalPrice,
      'createdAt': createdAt,
      'deliveryAddress': deliveryAddress,
      'shoppingMethod': shoppingMethod,
      'orderId': orderId,
      'latitude': latitude,
      'longitude': longitude,
      'trackingNumber': trackingNumber
    };
  }
}
