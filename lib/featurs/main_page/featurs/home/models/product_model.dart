import 'dart:convert';
import 'dart:developer';

class ProductModel {
  int id;
  double price;
  String name;
  String makerCompany;
  String sizes;
  String colors;
  String discription;
  String imgUrl;
  double disCount;
  String date;
  bool isFavorite;
  String? category;
  bool isNew;
  bool isDisCountUpdated;
  ProductModel(
      {required this.isDisCountUpdated,
      required this.imgUrl,
      required this.name,
      required this.makerCompany,
      required this.sizes,
      required this.colors,
      required this.discription,
      required this.id,
      required this.price,
      required this.date,
      required this.disCount,
      required this.isFavorite,
      required this.isNew,
      this.category});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'isNew': isNew,
      'category': category,
      'isFavorate': isFavorite,
      'date': date,
      'disCount': disCount,
      'imgUrl': imgUrl,
      'id': id,
      'price': price,
      'name': name,
      'makerCompany': makerCompany,
      'sizes': sizes,
      'colors': colors,
      'discription': discription,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    log(map['isNew'].toString());
    return ProductModel(
      isDisCountUpdated:
          map['isDiscountUpdated'] != null && map['isDiscountUpdated'] == 1
              ? true
              : false,
      isNew: map['isNew'] == 1 && map['isNew'] != null ? true : false,
      category: map['category'],
      isFavorite: map['isFavorate'] == 'true' ? true : false,
      date: map['date'] as String,
      disCount: map['discount'] * 1.0 ?? 0.0,
      imgUrl: map['imgUrl'] as String,
      id: map['id'] ?? 0,
      price: double.parse(map['price'].toString()),
      name: map['name'] as String,
      makerCompany: map['makerCompany'] as String,
      sizes: map['sizes'] as String,
      colors: map['colors'] as String,
      discription: map['discription'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) =>
      ProductModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
