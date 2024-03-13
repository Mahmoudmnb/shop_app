import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../injection.dart';
import '../../check_out/models/address_model.dart';
import '../../check_out/screens/add_another_address.dart';
import '../cubit/profile_cubit.dart';

class ShoppingAddressCard extends StatelessWidget {
  final AddressModel addressModel;
  const ShoppingAddressCard({super.key, required this.addressModel});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        ProfileCubit cubit = ProfileCubit.get(context);
        String? defaultLocation =
            sl.get<SharedPreferences>().getString('defaultLocation');
        if (defaultLocation != null) {
          context.read<ProfileCubit>().selectAddress = defaultLocation;
        }
        return Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                offset: const Offset(0, 11),
                blurRadius: 11,
                color: Colors.black.withOpacity(0.04))
          ], color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: MaterialButton(
            padding:
                EdgeInsets.only(left: 8.w, top: 8.h, right: 16.w, bottom: 16.h),
            onPressed: () {
              cubit.changeAddress(addressModel.addressName);
            },
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(bottom: 16.h),
                        child: Radio(
                            activeColor: Colors.black,
                            value: addressModel.addressName,
                            groupValue: cubit.selectAddress,
                            onChanged: (value) {
                              cubit.changeAddress(value!);
                            }),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8.h),
                          Text(
                            addressModel.addressName,
                            style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'DM Sans'),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            addressModel.address,
                            style: const TextStyle(
                                color: Color(0xFF828282),
                                fontFamily: 'Tenor Sans'),
                          ),
                        ],
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (_) => AddNewAddress(
                              type: 'Edit',
                              data: addressModel.toMap(),
                              fromPage: 'Profile')));
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 2),
                      margin: EdgeInsets.only(right: 8.w, top: 16.h),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: const Color(0xFFD57676))),
                      child: Text(
                        "Edit",
                        style: TextStyle(
                            fontSize: 8.sp,
                            fontFamily: 'Tenor Sans',
                            color: const Color(0xFFD57676)),
                      ),
                    ),
                  )
                ]),
          ),
        );
      },
    );
  }
}
