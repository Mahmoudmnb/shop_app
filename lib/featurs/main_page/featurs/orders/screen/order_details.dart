import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop_app/injection.dart';

import '../../../data_source/data_source.dart';
import '../../home/models/product_model.dart';
import '../model/order_model.dart';
import '../widgets/checkout_list.dart';
import '../widgets/item_card.dart';
import '../widgets/order_details_card.dart';

class OrderDetails extends StatelessWidget {
  final OrderModel order;
  final bool isDeliverd;
  final List<String> amounts;
  final List<String> colors;
  final List<String> sizes;
  const OrderDetails(
      {super.key,
      required this.order,
      required this.isDeliverd,
      required this.amounts,
      required this.colors,
      required this.sizes});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: sl.get<DataSource>().getProductsByIds(order.ordersIds),
        builder: (ctx, snapshot) => !snapshot.hasData
            ? const Center(child: CircularProgressIndicator())
            : Scaffold(
                body: SingleChildScrollView(
                  // physics: const NeverScrollableScrollPhysics(),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 60.h),
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
                                image: const AssetImage(
                                    "assets/images/backicon.png"),
                              )),
                          SizedBox(width: 8.w),
                          Text(
                            "Order #${order.orderId}",
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
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  offset: const Offset(0, 11),
                                  blurRadius: 11,
                                  color: Colors.black.withOpacity(.2))
                            ],
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          isDeliverd
                              ? "Your order is delivered"
                              : "Your order is pending",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'DM Sans',
                              fontSize: 16.sp),
                        ),
                      ),
                      SizedBox(height: 30.h),
                      OrderDetailsCard(
                        orderNumber: order.orderId,
                        trackingNumber: order.trackingNumber,
                        deliberyAddress: order.deliveryAddress,
                        shoppingMethod: order.shoppingMethod,
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
                        itemBuilder: (context, index) {
                          ProductModel product =
                              ProductModel.fromMap(snapshot.data![index]);

                          return ItemCard(
                            title: product.name,
                            price: product.price,
                            type: product.makerCompany,
                            color: Color(int.parse(colors[index])),
                            size: sizes[index],
                            quantity: int.parse(amounts[index]),
                            url: product.imgUrl.split('|')[0],
                          );
                        },
                        itemCount: order.ordersIds.split('|').length,
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
                      CheckOutList(
                        products: snapshot.data!,
                        order: order,
                        amounts: amounts,
                        colors: colors,
                        sizes: sizes,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 30.w),
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 15.h),
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10)),
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
              ));
  }
}
