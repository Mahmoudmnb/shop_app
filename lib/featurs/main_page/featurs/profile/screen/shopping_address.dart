import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../model/shopping_address_model.dart';
import '../widgets/shopping_address_card.dart';

class ShoppingAddress extends StatelessWidget {
  const ShoppingAddress({super.key});
  @override
  Widget build(BuildContext context) {
    List addressInfo = [
      ShoppingAddressModel(
          title: 'My Home', description: " 123 Building, Main Street"),
      ShoppingAddressModel(
          title: 'My Office', description: " 123 Building, Main Street"),
    ];
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
                    SizedBox(
                      width: 8.w,
                    ),
                    Text(
                      "Shopping Address",
                      style:
                          TextStyle(fontSize: 16.sp, fontFamily: 'Tenor Sans'),
                    )
                  ],
                ),
                SizedBox(
                  height: 40.h,
                ),
                Expanded(
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    separatorBuilder: (context, index) => SizedBox(
                      height: 2.h,
                    ),
                    itemCount: addressInfo.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ShoppingAddressCard(
                          title: addressInfo[index].title,
                          description: addressInfo[index].description);
                    },
                  ),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {},
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
                SizedBox(
                  height: 16.h,
                )
              ],
            )));
  }
}
