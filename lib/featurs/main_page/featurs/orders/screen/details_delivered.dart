import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop_app/featurs/main_page/featurs/orders/widgets/checkout_list.dart';
import 'package:shop_app/featurs/main_page/featurs/orders/widgets/item_card.dart';

import '../widgets/order_details_card.dart';

class DetailsDelivered extends StatelessWidget {
  const DetailsDelivered({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        // physics: const NeverScrollableScrollPhysics(),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 60.h),
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
                  width: 8.w,
                ),
                Text(
                  "Order #1680",
                  style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Tenor Sans'),
                )
              ],
            ),
            SizedBox(height: 40.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 13.h),
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    offset: const Offset(0, 11),
                    blurRadius: 11,
                    color: Colors.black.withOpacity(.2))
              ], color: Colors.black, borderRadius: BorderRadius.circular(10)),
              child: Text(
                "Your order is delivered",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'DM Sans',
                    fontSize: 16.sp),
              ),
            ),
            SizedBox(height: 30.h),
            const OrderDetailsCard(
              orderNumber: '1680',
              trackingNumber: 'Ik203019u203',
              deliberyAddress: '123 building Main Street',
              shoppingMethod: 'Standard delivery',
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 15.h),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 1, color: Colors.black)),
              child: Text(
                "Items",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: "Tenor Sans",
                    shadows: [
                      Shadow(
                          color: Colors.black.withOpacity(.1),
                          blurRadius: 4,
                          offset: const Offset(0, 4))
                    ]),
              ),
            ),
            ListView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) => const ItemCard(
                title: 'Flydat shirt',
                price: 39,
                type: 'Brand Zara',
                color: Colors.black,
                size: 'L',
                quantity: 1,
                url: 'assets/images/8.jpg',
              ),
              itemCount: 3,
            ),
            SizedBox(height: 20.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 15.h),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 1, color: Colors.black)),
              child: Text(
                "Checkout",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: "Tenor Sans",
                    shadows: [
                      Shadow(
                          color: Colors.black.withOpacity(.1),
                          blurRadius: 4,
                          offset: const Offset(0, 4))
                    ]),
              ),
            ),
            const CheckOutList(),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30.w),
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 15.h),
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(10)),
              child: const Text(
                "Rate",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: "DM Sans"),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
