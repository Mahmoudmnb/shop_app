class AddressModel {
  String? id;
  final String fullName;
  final String lastName;
  final String phoneNumber;
  final String emailAddress;
  final String addressName;
  final String longitude;
  final String latitude;
  final String city;
  final String country;
  final String address;

  AddressModel(
      {this.id,
      required this.fullName,
      required this.lastName,
      required this.phoneNumber,
      required this.emailAddress,
      required this.addressName,
      required this.longitude,
      required this.latitude,
      required this.city,
      required this.country,
      required this.address});

  Map<String, dynamic> toMap() {
    return {
      'id': id ?? '',
      'firstName': fullName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'emailAddress': emailAddress,
      'addressName': addressName,
      'longitude_code': longitude,
      'latitude_code': latitude,
      'city': city,
      'country': country,
      'address': address
    };
  }

  factory AddressModel.fromMap(Map<String, dynamic> location) {
    return AddressModel(
        id: location['id'],
        fullName: location['firstName'] as String,
        lastName: location['lastName'] as String,
        phoneNumber: location['phoneNumber'] as String,
        emailAddress: location['emailAddress'] as String,
        addressName: location['addressName'] as String,
        longitude: location['longitude_code'] as String,
        latitude: location['latitude_code'] as String,
        city: location['city'] as String,
        country: location['country'] as String,
        address: location['address'] as String);
  }
}
