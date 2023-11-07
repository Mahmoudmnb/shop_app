import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop_app/featurs/main_page/featurs/check_out/screens/add_another_address.dart';
import 'package:shop_app/gogole_map.dart';

import '../../profile/model/shopping_address_model.dart';
import '../widget/check_out_address.dart';
import '../widget/check_out_method.dart';
import '../widget/code_textfild.dart';
import '../widget/point.dart';
import 'second_step.dart';

class CheckOutScreen1 extends StatelessWidget {
  const CheckOutScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    List addressInfo = [
      ShoppingAddressModel(
          title: 'My Home', description: " 123 Building, Main Street"),
      ShoppingAddressModel(
          title: 'My Office', description: " 123 Building, Main Street"),
    ];
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 60.h),
            child: Row(
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
                  "Check out",
                  style: TextStyle(fontSize: 18.sp, fontFamily: 'Tenor Sans'),
                )
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                padding: EdgeInsets.only(left: 20.w, right: 20.w),
                child: Column(children: [
                  SizedBox(height: 20.h),
                  Row(
                    children: [
                      const Spacer(),
                      Image(
                          height: 25.h,
                          image:
                              const AssetImage('assets/images/location.png')),
                      SizedBox(
                        width: 10.w,
                      ),
                      const CheckOutPoint(),
                      const CheckOutPoint(),
                      const CheckOutPoint(),
                      const CheckOutPoint(),
                      const CheckOutPoint(),
                      SizedBox(width: 10.w),
                      Image(
                          height: 25.h,
                          image:
                              const AssetImage('assets/images/greycard.png')),
                      SizedBox(
                        width: 10.w,
                      ),
                      const CheckOutPoint(),
                      const CheckOutPoint(),
                      const CheckOutPoint(),
                      const CheckOutPoint(),
                      const CheckOutPoint(),
                      SizedBox(width: 10.w),
                      Image(
                          height: 25.h,
                          image: const AssetImage(
                              'assets/images/grey_check_out.png')),
                      const Spacer(),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 15.h),
                    width: double.infinity,
                    child: Text(
                      "Shopping Address",
                      style: TextStyle(
                          color: const Color(0xFF939393),
                          fontSize: 18.sp,
                          fontFamily: 'DM Sans'),
                    ),
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 15.h),
                    itemCount: addressInfo.length,
                    itemBuilder: (BuildContext context, int index) {
                      return CheckOutAddressCard(
                          title: addressInfo[index].title,
                          description: addressInfo[index].description);
                    },
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                        builder: (context) => const GoogleMapScreen(),
                      ))
                          .then((pickedLocation) {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AddNewAddress(
                            pickedLocation: pickedLocation,
                          ),
                        ));
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(vertical: 15.h),
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 15.h),
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                offset: const Offset(0, 11),
                                blurRadius: 11,
                                color: Colors.black.withOpacity(0.04))
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)),
                      child: Text(
                        " +  Add Another Address",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontFamily: 'DM Sans',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 8.h, bottom: 8.h),
                    width: double.infinity,
                    child: Text(
                      "Shopping Method",
                      style: TextStyle(
                          color: const Color(0xFF939393),
                          fontSize: 18.sp,
                          fontFamily: 'DM Sans'),
                    ),
                  ),
                  const CheckOutMethodCard(
                      price: 'Free ',
                      title: "In store pick-up",
                      description: "Up until 30 days after placing order"),
                  SizedBox(height: 15.h),
                  const CheckOutMethodCard(
                      price: '\$4.99',
                      title: "Standard delivery",
                      description: "Delivery by Mon, April 5th"),
                  SizedBox(height: 15.h),
                  const CheckOutMethodCard(
                      price: '\$9.99',
                      title: "Express delivery",
                      description: "Same-day delivery"),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 15.h),
                    width: double.infinity,
                    child: Text(
                      "Coupon Code",
                      style: TextStyle(
                          color: const Color(0xFF939393),
                          fontSize: 18.sp,
                          fontFamily: 'DM Sans'),
                    ),
                  ),
                  const CodeTextFeild(),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const CheckOutScreen2(),
                      ));
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 24.h),
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 13.h),
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        "Continue to payment",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'DM Sans',
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp),
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
