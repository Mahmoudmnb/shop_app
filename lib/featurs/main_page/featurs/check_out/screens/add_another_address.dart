import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import '../../../../../core/country_codes.dart';
import '../../../../../core/internet_info.dart';
import '../../../../../gogole_map.dart';
import '../../../../../injection.dart';
import '../../../data_source/data_source.dart';
import '../../profile/screen/shopping_address.dart';
import '../cubit/check_out_cubit.dart';
import '../models/address_model.dart';
import '../widget/text_field_address.dart';
import 'first_step.dart';

class AddNewAddress extends StatefulWidget {
  final Map<String, dynamic> data;
  final String fromPage;
  final String type;
  final CheckOutCubit checkOutCubit;
  const AddNewAddress(
      {super.key,
      required this.checkOutCubit,
      required this.data,
      required this.fromPage,
      required this.type});

  @override
  State<AddNewAddress> createState() => _AddNewAddressState();
}

class _AddNewAddressState extends State<AddNewAddress> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  late CheckOutCubit checkOutCubit;
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  TextEditingController fullNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
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
    phoneNumberController.dispose();
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
    LatLng? sourceLocation;
    Placemark? placemark;
    checkOutCubit = widget.checkOutCubit;
    if (widget.type == 'Edit') {
      latController.text = widget.data['latitude_code'];
      longController.text = widget.data['longitude_code'];
      cityController.text = widget.data['city'];
      countryController.text = widget.data['country'];
      addressController.text = widget.data['address'];
      int n = widget.data['phoneNumber'].toString().length - 9;
      widget.checkOutCubit.selectedCountryCode =
          widget.data['phoneNumber'].toString().substring(0, n);
      fullNameController.text = widget.data['firstName'];
      phoneNumberController.text =
          widget.data['phoneNumber'].toString().substring(n);
      emailAddressController.text = widget.data['emailAddress'];
      addressNameController.text = widget.data['addressName'];
      var dl = sl.get<SharedPreferences>().getString('defaultLocation');
      checkOutCubit.changeIsDelfaultLocatoin(dl == widget.data['addressName']);
    } else {
      sourceLocation = widget.data['sourceLocation'];
      placemark = widget.data['placeMark'];
      latController.text = sourceLocation!.latitude.toString();
      longController.text = sourceLocation.longitude.toString();
      cityController.text = placemark!.locality.toString();
      countryController.text = placemark.country.toString();
      addressController.text =
          '${placemark.locality}, ${placemark.subLocality == '' ? placemark.street : placemark.subLocality}';
      countryCode = countryCodes
          .where((element) =>
              element['code'] == placemark!.isoCountryCode!.toUpperCase() ||
              element['name']!.toUpperCase() ==
                  placemark.country!.toUpperCase())
          .toList();
      widget.checkOutCubit.selectedCountryCode = countryCode[0]['dial_code'];
    }
    super.initState();
  }

  backToGoogleMapScreen() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => GoogleMapScreen(
        fromPage: widget.fromPage,
        currentLocation: widget.data['sourceLocation'],
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    String? defaultLocation =
        sl.get<SharedPreferences>().getString('defaultLocation');
    if (widget.type != 'Edit') {
      widget.checkOutCubit.isDelfaultLocatoin = (defaultLocation == null);
    }
    return PopScope(
      canPop: false,
      onPopInvoked: (value) async {
        if (widget.type == 'Edit') {
          var data = await sl.get<DataSource>().getLocations();
          if (context.mounted) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (_) => ShoppingAddress(addressList: data)));
          }
        } else {
          backToGoogleMapScreen();
        }
      },
      child: SafeArea(
        child: Scaffold(
          body: Container(
            padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h),
            child: Column(children: [
              Row(
                children: [
                  GestureDetector(
                      onTap: () async {
                        if (widget.type == 'Edit') {
                          var data = await sl.get<DataSource>().getLocations();
                          if (context.mounted) {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (_) =>
                                        ShoppingAddress(addressList: data)));
                          }
                        } else {
                          backToGoogleMapScreen();
                        }
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
                        type: widget.type,
                        title: 'Full Name',
                        controller: fullNameController),
                    TextFieldAddress(
                        type: widget.type,
                        countryCode: countryCode,
                        title: 'Phone Number',
                        controller: phoneNumberController,
                        keyboardType: TextInputType.number),
                    TextFieldAddress(
                        type: widget.type,
                        title: 'Email Address',
                        controller: emailAddressController,
                        keyboardType: TextInputType.emailAddress),
                    TextFieldAddress(
                        type: widget.type,
                        title: 'Address Name',
                        controller: addressNameController,
                        keyboardType: TextInputType.streetAddress),
                    TextFieldAddress(
                        type: widget.type,
                        title: 'latitude code',
                        controller: latController),
                    TextFieldAddress(
                        type: widget.type,
                        title: 'longitude code',
                        controller: longController),
                    TextFieldAddress(
                        type: widget.type,
                        title: 'City',
                        controller: cityController),
                    TextFieldAddress(
                        type: widget.type,
                        title: 'Country',
                        controller: countryController),
                    TextFieldAddress(
                        type: widget.type,
                        title: 'Address',
                        controller: addressController),
                    SizedBox(
                      width: 393.w,
                      child: Row(
                        children: [
                          const Spacer(),
                          Expanded(
                            flex: 4,
                            child: BlocBuilder<CheckOutCubit, CheckOutState>(
                              builder: (context, state) {
                                bool isDefaultLocation =
                                    checkOutCubit.isDelfaultLocatoin;
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
                                      if (widget.type == 'Edit' &&
                                          value == false) {
                                      } else {
                                        checkOutCubit
                                            .changeIsDelfaultLocatoin(value!);
                                      }
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
                        //todo: i have to replace last name and first name with full name
                        if (!checkOutCubit
                            .getIsUpdateAddLocationButtonLoading) {
                          checkOutCubit.setIsUpdateAddLocationButtonLoading =
                              true;
                          InternetInfo.isconnected().then((value) async {
                            if (value) {
                              var value = await checkOutCubit.getLocationByName(
                                  addressNameController.text.trim());
                              checkOutCubit.isAddressNameIsAvailable =
                                  value.isEmpty;
                              if (formState.currentState!.validate()) {
                                AddressModel address = AddressModel(
                                    fullName: fullNameController.text.trim(),
                                    lastName: fullNameController.text.trim(),
                                    phoneNumber:
                                        checkOutCubit.selectedCountryCode +
                                            phoneNumberController.text.trim(),
                                    emailAddress:
                                        emailAddressController.text.trim(),
                                    addressName:
                                        addressNameController.text.trim(),
                                    longitude: longController.text.trim(),
                                    latitude: latController.text.trim(),
                                    city: cityController.text.trim(),
                                    country: countryController.text.trim(),
                                    address: addressController.text.trim());
                                if (checkOutCubit.isAddressNameIsAvailable) {
                                  if (widget.fromPage == 'Orders') {
                                    checkOutCubit
                                        .addNewAdress(address)
                                        .then((value) {
                                      checkOutCubit
                                          .getLocations()
                                          .then((value) {
                                        Navigator.of(context)
                                            .pushReplacement(MaterialPageRoute(
                                          builder: (context) =>
                                              FirstStep(locations: value),
                                        ));
                                      });
                                    });
                                  } else {
                                    if (widget.type == 'Edit') {
                                      address.id = widget.data['id'];
                                      bool isSuccess = await sl
                                          .get<DataSource>()
                                          .updateAddress(address,
                                              widget.data['addressName']);
                                      if (!isSuccess) {
                                        if (context.mounted) {
                                          Toast.show(
                                              'Someting went wrong please try again');
                                        }
                                      } else {
                                        var addressList = await sl
                                            .get<DataSource>()
                                            .getLocations();
                                        if (context.mounted) {
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      ShoppingAddress(
                                                          addressList:
                                                              addressList)));
                                        }
                                      }
                                    } else {
                                      await checkOutCubit.addNewAdress(address);
                                      var addressList = await sl
                                          .get<DataSource>()
                                          .getLocations();
                                      if (context.mounted) {
                                        Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder: (_) => ShoppingAddress(
                                                    addressList: addressList)));
                                      }
                                    }
                                  }
                                }
                                if (context.mounted) {
                                  if (defaultLocation == null ||
                                      checkOutCubit.isDelfaultLocatoin) {
                                    sl.get<SharedPreferences>().setString(
                                        'defaultLocation',
                                        addressNameController.text.trim());
                                  }
                                  checkOutCubit
                                          .setIsUpdateAddLocationButtonLoading =
                                      false;
                                }
                              } else {
                                checkOutCubit
                                        .setIsUpdateAddLocationButtonLoading =
                                    false;
                                setState(() {
                                  autovalidateMode = AutovalidateMode.always;
                                });
                              }
                            } else {
                              checkOutCubit
                                  .setIsUpdateAddLocationButtonLoading = false;
                              if (context.mounted) {
                                Toast.show('check your internet connection',
                                    duration: Toast.lengthLong);
                              }
                            }
                          });
                        }
                      },
                      child: Ink(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 15.h),
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10)),
                        child: BlocBuilder<CheckOutCubit, CheckOutState>(
                          builder: (context, state) {
                            return checkOutCubit
                                    .getIsUpdateAddLocationButtonLoading
                                ? const Center(
                                    child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ))
                                : Text(
                                    widget.type == 'Edit'
                                        ? 'Edit address'
                                        : "Add new address",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 15.sp,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "DM Sans"),
                                  );
                          },
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
