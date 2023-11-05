import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddNewAddress extends StatefulWidget {
  final LatLng pickedLocation;
  const AddNewAddress({super.key, required this.pickedLocation});

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
    latController.text = widget.pickedLocation.latitude.toString();
    longController.text = widget.pickedLocation.longitude.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 60.h),
        child: Column(children: [
          Row(
            children: [
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Image(
                    height: 40.w,
                    width: 40.w,
                    image: const AssetImage("assets/images/backicon.png"),
                  )),
              SizedBox(
                width: 10.w,
              ),
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
              buildTextFeild(title: 'LastName', controller: lastNameController),
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
              buildTextFeild(title: 'latitude code', controller: latController),
              buildTextFeild(
                  title: 'longitude code', controller: longController),
              buildTextFeild(title: 'City', controller: cityController),
              buildTextFeild(title: 'Country', controller: countryController),
              buildTextFeild(title: 'Address', controller: addressController),
              Container(
                margin: EdgeInsets.only(
                    left: 10.w, right: 10.w, bottom: 20.h, top: 20.h),
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
            ],
          )),
        ]),
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
      child: TextField(
        readOnly: title == 'longitude code' || title == 'latitude code'
            ? true
            : false,
        keyboardType: keyboardtype,
        controller: controller,
        decoration: InputDecoration(
            label: Text(title),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      ),
    );
  }
}
