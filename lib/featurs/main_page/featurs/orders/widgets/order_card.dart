import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop_app/featurs/main_page/featurs/orders/screen/details_delivered.dart';

import '../model/card_model.dart';

class BuildOrderCard extends StatelessWidget {
  final CardModel card;
  const BuildOrderCard({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                offset: const Offset(0, 11),
                blurRadius: 24,
                color: Colors.black.withOpacity(.09))
          ]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          "Order #${card.numb}",
          style: TextStyle(
              fontFamily: "DM Sans",
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                    offset: const Offset(0, 4),
                    color: Colors.black.withOpacity(.25),
                    blurRadius: 4)
              ]),
        ),
        SizedBox(
          height: 8.h,
        ),
        Row(
          children: [
            Expanded(
              // flex: 6,
              child: Row(
                children: [
                  Text(
                    "Order date",
                    style: TextStyle(
                        fontFamily: 'Tenor Sans',
                        color: const Color(0xFF828282),
                        fontSize: 13.sp),
                  ),
                  SizedBox(
                    width: 8.w,
                  ),
                  Text(
                    "${card.orderDate.day}/${card.orderDate.month}/${card.orderDate.year}",
                    style: TextStyle(color: Colors.black, fontSize: 13.sp),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 8.w,
            ),
            Expanded(
              // flex: 4,
              child: Row(
                children: [
                  Text(
                    "due date",
                    style: TextStyle(
                        fontFamily: 'Tenor Sans',
                        color: const Color(0xFF828282),
                        fontSize: 13.sp),
                  ),
                  SizedBox(
                    width: 8.w,
                  ),
                  Text(
                    "${card.dueDate.day}/${card.dueDate.month}/${card.dueDate.year}",
                    style: TextStyle(color: Colors.black, fontSize: 13.sp),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 8.h,
        ),
        Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              // flex: 6,
              child: Row(
                children: [
                  const Text(
                    "Quantity:",
                    style: TextStyle(
                        fontFamily: 'Tenor Sans', color: Color(0xFF828282)),
                  ),
                  SizedBox(
                    width: 8.w,
                  ),
                  Text(
                    "${card.quantity}",
                    style: const TextStyle(
                        fontFamily: 'Tenor Sans', color: Colors.black),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 8.w,
            ),
            Expanded(
              // flex: 4,
              child: Row(
                children: [
                  const Text(
                    "Subtotal",
                    style: TextStyle(
                        fontFamily: 'Tenor Sans', color: Color(0xFF828282)),
                  ),
                  SizedBox(
                    width: 8.w,
                  ),
                  Text(
                    "${card.subtotal}\$",
                    style: const TextStyle(
                        fontFamily: 'Tenor Sans', color: Colors.black),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 8.h,
        ),
        Row(
          children: [
            const Text(
              "Tracking number:",
              style:
                  TextStyle(fontFamily: 'Tenor Sans', color: Color(0xFF828282)),
            ),
            SizedBox(
              width: 8.w,
            ),
            Text(
              card.trackingNumber,
              style: const TextStyle(
                  fontFamily: 'Tenor Sans', color: Colors.black),
            ),
          ],
        ),
        SizedBox(
          height: 8.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              card.kingOfOrder,
              style: TextStyle(
                  fontFamily: 'Tenor Sans',
                  color: card.kingOfOrder == "Pending"
                      ? const Color(0xFFD57676)
                      : const Color(0xFF76D5AD),
                  fontSize: 15.sp),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const DetailsDelivered(),
                ));
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                          offset: const Offset(0, 4),
                          blurRadius: 4,
                          color: Colors.black.withOpacity(.25))
                    ],
                    border: Border.all(color: const Color(0xFF434343))),
                child: const Text(
                  "Details",
                  style: TextStyle(
                    fontFamily: 'Tenor Sans',
                  ),
                ),
              ),
            )
          ],
        )
      ]),
    );
  }
}
