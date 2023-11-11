class AddressModel {
  final String firstName;
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
      {required this.firstName,
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
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'emailAddress': emailAddress,
      'addressName': addressName,
      'longitude': longitude,
      'latitude': latitude,
      'city': city,
      'country': country,
      'address': address
    };
  }

  factory AddressModel.fromMap(Map<String, dynamic> locations) {
    return AddressModel(
        firstName: locations['firstName'],
        lastName: locations['lastName'],
        phoneNumber: locations['phoneNumber'],
        emailAddress: locations['emailAddress'],
        addressName: locations['addressName'],
        longitude: locations['longitude'],
        latitude: locations['latitude'],
        city: locations['city'],
        country: locations['country'],
        address: locations['address']);
  }
}
