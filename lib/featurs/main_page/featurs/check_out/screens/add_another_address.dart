import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/gogole_map.dart';
import 'package:shop_app/injection.dart';
import 'package:toast/toast.dart';

import '../../../../../core/country_codes.dart';
import '../../../../../core/internet_info.dart';
import '../cubit/check_out_cubit.dart';
import '../models/address_model.dart';
import '../widget/text_field_address.dart';
import 'first_step.dart';

class AddNewAddress extends StatefulWidget {
  final Map<String, dynamic> data;
  const AddNewAddress({super.key, required this.data});

  @override
  State<AddNewAddress> createState() => _AddNewAddressState();
}

class _AddNewAddressState extends State<AddNewAddress> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  TextEditingController fullNameController = TextEditingController();
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
    fullNameController.dispose();
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
    String? defaultLocation =
        sl.get<SharedPreferences>().getString('defaultLocation');
    context.read<CheckOutCubit>().isDelfaultLocatoin =
        (defaultLocation == null);
    return WillPopScope(
      onWillPop: () async {
        backToGoogleMapScreen();
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          body: Container(
            padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h),
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
                  child: Form(
                key: formState,
                autovalidateMode: autovalidateMode,
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    TextFieldAddress(
                        title: 'Full Name', controller: fullNameController),
                    TextFieldAddress(
                        countryCode: countryCode,
                        title: 'Phone Number',
                        controller: phoneNuberController,
                        keyboardType: TextInputType.number),
                    TextFieldAddress(
                        title: 'Email Address',
                        controller: emailAddressController,
                        keyboardType: TextInputType.emailAddress),
                    TextFieldAddress(
                        title: 'Address Name',
                        controller: addressNameController,
                        keyboardType: TextInputType.streetAddress),
                    TextFieldAddress(
                        title: 'latitude code', controller: latController),
                    TextFieldAddress(
                        title: 'longitude code', controller: longController),
                    TextFieldAddress(title: 'City', controller: cityController),
                    TextFieldAddress(
                        title: 'Country', controller: countryController),
                    TextFieldAddress(
                        title: 'Address', controller: addressController),
                    SizedBox(
                      width: 393.w,
                      child: Row(
                        children: [
                          const Spacer(),
                          Expanded(
                            flex: 4,
                            child: BlocBuilder<CheckOutCubit, CheckOutState>(
                              builder: (context, state) {
                                bool isDefaultLocation = context
                                    .read<CheckOutCubit>()
                                    .isDelfaultLocatoin;
                                return CheckboxListTile(
                                  shape: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(10)),
                                  checkColor: Colors.white,
                                  activeColor: Colors.black,
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  visualDensity: const VisualDensity(
                                      horizontal: -4, vertical: -4),
                                  title: Text(
                                    'Set as default location',
                                    style: TextStyle(fontSize: 14.sp),
                                  ),
                                  value: isDefaultLocation,
                                  onChanged: (value) {
                                    if (defaultLocation != null) {
                                      context
                                          .read<CheckOutCubit>()
                                          .changeIsDelfaultLocatoin(value!);
                                    }
                                  },
                                );
                              },
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h),
                    InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        //todo i have to replace last name and first name with full name
                        InternetInfo.isconnected().then((value) {
                          if (value) {
                            context
                                .read<CheckOutCubit>()
                                .getLocationByName(
                                    addressNameController.text.trim())
                                .then((value) {
                              log(value.toString());
                              context
                                  .read<CheckOutCubit>()
                                  .isAddressNameIsAvailable = value.isEmpty;
                            });
                            if (formState.currentState!.validate()) {
                              AddressModel address = AddressModel(
                                  fullName: fullNameController.text.trim(),
                                  lastName: fullNameController.text.trim(),
                                  phoneNumber: phoneNuberController.text.trim(),
                                  emailAddress:
                                      emailAddressController.text.trim(),
                                  addressName:
                                      addressNameController.text.trim(),
                                  longitude: longController.text.trim(),
                                  latitude: latController.text.trim(),
                                  city: cityController.text.trim(),
                                  country: countryController.text.trim(),
                                  address: addressController.text.trim());

                              if (context
                                  .read<CheckOutCubit>()
                                  .isAddressNameIsAvailable) {
                                context
                                    .read<CheckOutCubit>()
                                    .addNewAdress(address)
                                    .then((value) {
                                  context
                                      .read<CheckOutCubit>()
                                      .getLocations()
                                      .then((value) {
                                    Navigator.of(context)
                                        .pushReplacement(MaterialPageRoute(
                                      builder: (context) =>
                                          FirstStep(locations: value),
                                    ));
                                  });
                                });
                              }
                              if (defaultLocation == null ||
                                  context
                                      .read<CheckOutCubit>()
                                      .isDelfaultLocatoin) {
                                sl.get<SharedPreferences>().setString(
                                    'defaultLocation',
                                    addressNameController.text.trim());
                              }
                            }
                            setState(() {
                              autovalidateMode = AutovalidateMode.always;
                            });
                          } else {
                            ToastContext().init(context);
                            Toast.show('check your internet connection');
                          }
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
                    SizedBox(height: 10.h),
                  ],
                ),
              )),
            ]),
          ),
        ),
      ),
    );
  }

  void showMessage(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        shape: const OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        backgroundColor: Colors.grey,
        content: Center(
          child: Text(
            text,
            style: TextStyle(fontSize: 18.sp),
          ),
        )));
  }
}
