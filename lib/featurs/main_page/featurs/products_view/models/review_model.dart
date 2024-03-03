import 'dart:convert';

class ReviewModel {
  int? id;
  String email;
  String description;
  double stars;
  String date;
  String userName;
  String? userImage;
  int productId;
  ReviewModel({
    this.id,
    required this.email,
    required this.description,
    required this.stars,
    required this.date,
    required this.userName,
    required this.userImage,
    required this.productId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'id': id,
      'description': description,
      'stars': stars,
      'date': date,
      'userName': userName,
      'userImage': userImage,
      'productId': productId,
    };
  }

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      email: map['email'] as String,
      id: map['id'],
      description: map['description'] as String,
      stars: map['stars'] * 1.0,
      date: map['date'] as String,
      userName: map['userName'] as String,
      userImage: map['userImage'],
      productId: map['productId'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory ReviewModel.fromJson(String source) =>
      ReviewModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
