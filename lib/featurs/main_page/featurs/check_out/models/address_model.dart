class AddressModel {
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
      {required this.fullName,
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

  factory AddressModel.fromMap(Map<String, dynamic> locations) {
    return AddressModel(
        fullName: locations['firstName'] as String,
        lastName: locations['lastName'] as String,
        phoneNumber: locations['phoneNumber'] as String,
        emailAddress: locations['emailAddress'] as String,
        addressName: locations['addressName'] as String,
        longitude: locations['longitude_code'] as String,
        latitude: locations['latitude_code'] as String,
        city: locations['city'] as String,
        country: locations['country'] as String,
        address: locations['address'] as String);
  }
}
