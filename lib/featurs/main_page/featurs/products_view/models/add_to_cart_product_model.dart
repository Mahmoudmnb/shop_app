import 'dart:convert';

class AddToCartProductModel {
  int? id;
  String productName;
  double price;
  int quantity;
  String companyMaker;
  String color;
  String size;
  String imgUrl;
  AddToCartProductModel(
      {this.id,
      required this.quantity,
      required this.color,
      required this.companyMaker,
      required this.productName,
      required this.price,
      required this.size,
      required this.imgUrl});
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'productName': productName,
      'price': price,
      'quantity': quantity,
      'companyMaker': companyMaker,
      'color': color,
      'size': size,
      'imgUrl': imgUrl
    };
  }

  factory AddToCartProductModel.fromMap(Map<String, dynamic> map) {
    return AddToCartProductModel(
        id: map['id'] as int,
        productName: map['productName'] as String,
        price: map['price'] as double,
        quantity: map['quantity'] as int,
        companyMaker: map['companyMaker'] as String,
        color: map['color'] as String,
        size: map['size'] as String,
        imgUrl: map['imgUrl'] as String);
  }

  String toJson() => json.encode(toMap());

  factory AddToCartProductModel.fromJson(String source) =>
      AddToCartProductModel.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
