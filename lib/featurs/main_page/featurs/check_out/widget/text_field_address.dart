import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop_app/core/country_codes.dart';

import '../cubit/check_out_cubit.dart';

class TextFieldAddress extends StatelessWidget {
  const TextFieldAddress({
    super.key,
    required this.type,
    required this.title,
    required this.controller,
    this.keyboardType = TextInputType.name,
    this.countryCode,
    this.validator,
  });
  final String? Function(String?)? validator;
  final List<Map<String, dynamic>>? countryCode;
  final String title;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String type;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      // height: 50.h,
      child: TextFormField(
        onChanged: (value) {
          if (title == 'Address Name') {
            context
                .read<CheckOutCubit>()
                .getLocationByName(value.trim())
                .then((value) {
              log(value.toString());
              context.read<CheckOutCubit>().isAddressNameIsAvailable =
                  value.isEmpty;
            });
          }
        },
        onTapOutside: (event) {
          FocusScope.of(context).unfocus();
        },
        cursorColor: Colors.black,
        validator: (value) {
          if (title == 'Address Name' && type != 'Edit') {
            if (!context.read<CheckOutCubit>().isAddressNameIsAvailable) {
              return 'address name is used before please try another name';
            }
          }
          if (title == 'Full Name' || title == 'Address Name') {
            if (value == null || value.isEmpty || value.length < 3) {
              return '$title shold be more than three chrachters';
            }
          } else if (title == 'Phone Number') {
            if (value == null || value.isEmpty || value.length != 9) {
              return 'Phone Number shold be 9 digits';
            }
          } else if (title == 'Email Address') {
            if (value == null ||
                !value.contains('@') ||
                !value.endsWith('.com')) {
              return 'Invalid email';
            }
          }
          return null;
        },
        readOnly: title == 'longitude code' ||
            title == 'latitude code' ||
            title == 'City' ||
            title == 'Country' ||
            title == 'Address',
        keyboardType: keyboardType,
        controller: controller,
        decoration: InputDecoration(
            prefixIcon: title == 'Phone Number'
                ? DropdownButton(
                    dropdownColor: Colors.white,
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(left: 10.w),
                    menuMaxHeight: 300,
                    value: context
                        .watch<CheckOutCubit>()
                        .selectedCountryCode
                        .trim(),
                    underline: const SizedBox(),
                    items: [
                      ...List.generate(countryCodes.length, (index) {
                        return DropdownMenuItem(
                          value: countryCodes[index]['dial_code']!,
                          child: Text(countryCodes[index]['dial_code']!),
                        );
                      })
                    ],
                    onChanged: (value) {
                      context
                          .read<CheckOutCubit>()
                          .changeSelectedCountryCode(value);
                    })
                : null,
            label:
                Text(title, style: const TextStyle(color: Color(0xFF0C0C0C))),
            enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: Color(0xFF7E7E7E))),
            focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: Color(0xFF7E7E7E))),
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)))),
      ),
    );
  }
}
