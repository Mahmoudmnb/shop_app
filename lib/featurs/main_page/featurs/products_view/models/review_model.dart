import 'dart:convert';
class ReviewModel {
  int id;
  String description;
  int stars;
  String date;
  String userName;
  String userImage;
  int productId;
  ReviewModel({
    required this.id,
    required this.description,
    required this.stars,
    required this.date,
    required this.userName,
    required this.userImage,
    required this.productId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
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
      id: map['id'] as int,
      description: map['description'] as String,
      stars: map['stars'] as int,
      date: map['date'] as String,
      userName: map['userName'] as String,
      userImage: map['userImage'] as String,
      productId: map['productId'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory ReviewModel.fromJson(String source) => ReviewModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
