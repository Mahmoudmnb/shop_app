import 'dart:convert';

class UserModel {
  final String name;
  final String email;
  final String password;
  String? phoneNumber;
  String? imgUrl;
  String? cloudImgUrl;
  UserModel(
      {required this.email,
      required this.name,
      required this.password,
      this.cloudImgUrl,
      this.phoneNumber,
      this.imgUrl});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cloudImgUrl': cloudImgUrl,
      'phoneNumber': phoneNumber,
      'imgUrl': imgUrl,
      'name': name,
      'email': email,
      'password': password,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      cloudImgUrl: map['cloudImgUrl'],
      phoneNumber: map['phoneNumber'],
      imgUrl: map['imgUrl'],
      name: map['name'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
