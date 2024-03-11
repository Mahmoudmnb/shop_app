import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop_app/featurs/main_page/data_source/data_source.dart';
import 'package:shop_app/featurs/main_page/featurs/check_out/models/address_model.dart';
import 'package:shop_app/gogole_map.dart';
import 'package:shop_app/injection.dart';

import '../widgets/shopping_address_card.dart';

class ShoppingAddress extends StatelessWidget {
  final List<Map<String, dynamic>> addressList;
  const ShoppingAddress({super.key, required this.addressList});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 60.h),
            child: Column(
              children: [
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
                    SizedBox(width: 8.w),
                    Text(
                      "Shopping Address",
                      style:
                          TextStyle(fontSize: 18.sp, fontFamily: 'Tenor Sans'),
                    )
                  ],
                ),
                SizedBox(height: 40.h),
                Expanded(
                  child: ListView.separated(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    physics: const BouncingScrollPhysics(),
                    separatorBuilder: (context, index) => SizedBox(height: 2.h),
                    itemCount: addressList.length,
                    itemBuilder: (BuildContext context, int index) {
                      AddressModel address =
                          AddressModel.fromMap(addressList[index]);
                      return Dismissible(
                        background: Container(
                          padding: EdgeInsets.only(left: 19.65.w),
                          alignment: Alignment.centerLeft,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        secondaryBackground: Container(
                          // margin: EdgeInsets.only(left: 7.6335.w),
                          padding: EdgeInsets.only(right: 19.65.w),
                          alignment: Alignment.centerRight,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (value) async {
                          await sl
                              .get<DataSource>()
                              .deleteAddress(address.addressName);
                        },
                        key: Key(address.addressName),
                        child: ShoppingAddressCard(
                          addressModel: address,
                        ),
                      );
                    },
                  ),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (_) => const GoogleMapScreen(
                              fromPage: 'Profile',
                            )));
                  },
                  child: Ink(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 13.h),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      "Add new address",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'DM Sans',
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp),
                    ),
                  ),
                ),
                SizedBox(height: 16.h)
              ],
            )));
  }
}
