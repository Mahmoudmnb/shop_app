import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../home/models/product_model.dart';
import '../model/order_model.dart';

class CheckOutList extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final OrderModel order;
  const CheckOutList({super.key, required this.products, required this.order});

  @override
  Widget build(BuildContext context) {
    double deliveryCost = order.shoppingMethod == 'Standard delivery'
        ? 4.99
        : order.shoppingMethod == 'In store pick-up'
            ? 0
            : 9.99;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 30.h),
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      // height: 400.h,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                offset: const Offset(0, 11),
                blurRadius: 11,
                color: Colors.black.withOpacity(.1))
          ]),
      child: Column(
        children: [
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: products.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              ProductModel product = ProductModel.fromMap(products[index]);
              return Container(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontFamily: 'Tenor Sans',
                        color: Color(0xFF393939),
                      ),
                    ),
                    Row(
                      children: [
                        const Text('x 1'),
                        SizedBox(width: 30.w),
                        Text('${product.price.toStringAsFixed(2)}\$'),
                      ],
                    )
                  ],
                ),
              );
            },
          ),
          SizedBox(height: 50.h),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Sub Total",
                  style: TextStyle(
                    fontFamily: 'Tenor Sans',
                    color: Color(0xFF393939),
                  ),
                ),
                Text(
                    '${(order.totalPrice - deliveryCost).toStringAsFixed(2)} \$')
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Deliver",
                  style: TextStyle(
                    fontFamily: 'Tenor Sans',
                    color: Color(0xFF393939),
                  ),
                ),
                Text('$deliveryCost \$')
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Shipping",
                  style: TextStyle(
                    fontFamily: 'Tenor Sans',
                    color: Color(0xFF393939),
                  ),
                ),
                Text('10 \$')
              ],
            ),
          ),
          const Divider(thickness: 1),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total",
                  style: TextStyle(
                    fontFamily: 'Tenor Sans',
                    color: Color(0xFF393939),
                  ),
                ),
                Text('29.99 \$')
              ],
            ),
          ),
          SizedBox(height: 20.h)
        ],
      ),
    );
  }
}
