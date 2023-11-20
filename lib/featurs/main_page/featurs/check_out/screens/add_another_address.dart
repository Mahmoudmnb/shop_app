import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shop_app/core/country_codes.dart';
import 'package:shop_app/featurs/main_page/featurs/check_out/screens/first_step.dart';
import 'package:shop_app/gogole_map.dart';
import '../cubit/check_out_cubit.dart';
import '../models/address_model.dart';

class AddNewAddress extends StatefulWidget {
  final Map<String, dynamic> data;
  const AddNewAddress({super.key, required this.data});

  @override
  State<AddNewAddress> createState() => _AddNewAddressState();
}

class _AddNewAddressState extends State<AddNewAddress> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneNuberController = TextEditingController();
  TextEditingController emailAddressController = TextEditingController();
  TextEditingController addressNameController = TextEditingController();
  // TextEditingController postalCodeController = TextEditingController();
  TextEditingController latController = TextEditingController();
  TextEditingController longController = TextEditingController();

  TextEditingController cityController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  List<Map<String, dynamic>> countryCode = [];
  @override
  void dispose() {
    super.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    phoneNuberController.dispose();
    emailAddressController.dispose();
    addressNameController.dispose();
    latController.dispose();
    longController.dispose();
    cityController.dispose();
    countryController.dispose();
    addressController.dispose();
  }

  @override
  void initState() {
    LatLng sourceLocation = widget.data['sourceLocation'];
    Placemark placemark = widget.data['placeMark'];
    latController.text = sourceLocation.latitude.toString();
    longController.text = sourceLocation.longitude.toString();
    cityController.text = placemark.locality.toString();
    countryController.text = placemark.country.toString();
    addressController.text =
        '${placemark.locality}, ${placemark.subLocality == '' ? placemark.street : placemark.subLocality}';
    countryCode = countryCodes
        .where((element) =>
            element['code'] == placemark.isoCountryCode!.toUpperCase() ||
            element['name']!.toUpperCase() == placemark.country!.toUpperCase())
        .toList();
    log(countryCode.toString());
    super.initState();
  }

  backToGoogleMapScreen() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => GoogleMapScreen(
        currentLocation: widget.data['sourceLocation'],
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        backToGoogleMapScreen();
        return false;
      },
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 60.h),
          child: Column(children: [
            Row(
              children: [
                GestureDetector(
                    onTap: () {
                      backToGoogleMapScreen();
                    },
                    child: Image(
                      height: 40.w,
                      width: 40.w,
                      image: const AssetImage("assets/images/backicon.png"),
                    )),
                SizedBox(width: 10.w),
                Text(
                  "Add New Address",
                  style: TextStyle(
                      fontSize: 18.sp,
                      fontFamily: 'Tenor Sans',
                      fontWeight: FontWeight.w500),
                )
              ],
            ),
            Expanded(
                child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                buildTextFeild(
                    title: 'FirstName', controller: firstNameController),
                buildTextFeild(
                    title: 'LastName', controller: lastNameController),
                buildTextFeild(
                    title: 'Phone Number',
                    controller: phoneNuberController,
                    keyboardtype: TextInputType.number),
                buildTextFeild(
                    title: 'Email Address',
                    controller: emailAddressController,
                    keyboardtype: TextInputType.emailAddress),
                buildTextFeild(
                    title: 'Address Name',
                    controller: addressNameController,
                    keyboardtype: TextInputType.streetAddress),
                buildTextFeild(
                    title: 'latitude code', controller: latController),
                buildTextFeild(
                    title: 'longitude code', controller: longController),
                buildTextFeild(title: 'City', controller: cityController),
                buildTextFeild(title: 'Country', controller: countryController),
                buildTextFeild(title: 'Address', controller: addressController),
                InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    AddressModel address = AddressModel(
                        firstName: lastNameController.text.trim(),
                        lastName: lastNameController.text.trim(),
                        phoneNumber: phoneNuberController.text.trim(),
                        emailAddress: emailAddressController.text.trim(),
                        addressName: addressNameController.text.trim(),
                        longitude: longController.text.trim(),
                        latitude: latController.text.trim(),
                        city: cityController.text.trim(),
                        country: countryController.text.trim(),
                        address: addressController.text.trim());
                    context
                        .read<CheckOutCubit>()
                        .addNewAdress(address)
                        .then((value) {
                      context
                          .read<CheckOutCubit>()
                          .getLocations()
                          .then((value) {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => FirstStep(locations: value),
                        ));
                      });
                    });
                  },
                  child: Ink(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 15.h),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      "Add new address",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 15.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: "DM Sans"),
                    ),
                  ),
                ),
              ],
            )),
          ]),
        ),
      ),
    );
  }

  Widget buildTextFeild(
      {required String title,
      required TextEditingController controller,
      keyboardtype = TextInputType.name}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      height: 50.h,
      child: TextFormField(
        readOnly: title == 'longitude code' ||
            title == 'latitude code' ||
            title == 'City' ||
            title == 'Country' ||
            title == 'Address',
        keyboardType: keyboardtype,
        controller: controller,
        decoration: InputDecoration(
            prefix: title == 'Phone Number'
                ? Text(countryCode[0]['dial_code'] + '  ')
                : null,
            label: Text(title),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      ),
    );
  }
}
