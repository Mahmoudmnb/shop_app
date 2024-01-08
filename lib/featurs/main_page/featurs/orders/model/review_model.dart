class ReviewModel {
  final int? id;
  final String description;
  final double stars;
  final String date;
  final String userName;
  final String? userImgUrl;
  final int productId;

  ReviewModel(
      {this.id,
      required this.description,
      required this.stars,
      required this.date,
      required this.userName,
      required this.userImgUrl,
      required this.productId});
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'stars': stars,
      'date': date,
      'userName': userName,
      'userImgUrl': userImgUrl,
      'productId': productId
    };
  }

  factory ReviewModel.fromMap(Map<String, dynamic> review) {
    return ReviewModel(
        id: review['id'],
        description: review['description'],
        stars: review['stars'],
        date: review['date'],
        userName: review['userName'],
        userImgUrl: review['userImgUrl'],
        productId: review['productId']);
  }
}
