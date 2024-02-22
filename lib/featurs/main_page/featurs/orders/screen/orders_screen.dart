import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop_app/featurs/auth/pages/auth_page.dart';
import 'package:shop_app/injection.dart';

import '../../../../../core/constant.dart';
import '../../../data_source/data_source.dart';
import '../cubit/orders_cubit.dart';
import '../model/order_model.dart';
import '../widgets/order_card.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  @override
  Widget build(BuildContext context) {
    List<OrderModel> pendingOrders = [];
    List<OrderModel> deliverdOrders = [];
    return BlocBuilder<OrdersCubit, OrdersState>(
      builder: (context, state) {
        return FutureBuilder(
            future: sl.get<DataSource>().getOrders(),
            builder: (ctx, snapshot) {
              if (snapshot.hasData) {
                pendingOrders = [];
                deliverdOrders = [];
                List<Map<String, dynamic>> orders = snapshot.data!;
                for (var element in orders) {
                  OrderModel order = OrderModel.fromMap(element);
                  int deliveryTime =
                      order.shoppingMethod == 'Express delivery' ? 1 : 3;
                  if (DateTime.now()
                          .difference(Constant.stringToDate(order.createdAt))
                          .inDays >=
                      deliveryTime) {
                    deliverdOrders.add(order);
                  } else {
                    pendingOrders.add(order);
                  }
                }
              }
              return snapshot.hasData
                  ? Scaffold(
                      backgroundColor: Colors.white,
                      body: Constant.currentUser == null
                          ? Padding(
                            padding:  EdgeInsets.only(bottom: 30.h),
                            child: Center(
                              child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image(
                                  width: 300.w,
                                  height: 300.w,
                                    image:
                                        const AssetImage('assets/images/lock.png')),
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (_) => const AuthPage()))
                                          .then((value) {
                                        setState(() {});
                                      });
                                    },
                                    child: Text(
                                      'Register now',
                                      style: TextStyle(fontSize: 20.sp),
                                    ))
                              ],
                                                            ),
                            ),
                          )
                          : Column(
                              children: [
                                Container(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 30.w),
                                  child: Column(
                                    children: [
                                      const Divider(),
                                      SizedBox(height: 8.h),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              context
                                                  .read<OrdersCubit>()
                                                  .changeKingOfOrder('Pending');
                                            },
                                            child: Container(
                                              padding:
                                                  EdgeInsets.only(bottom: 8.h),
                                              width: 150.w,
                                              decoration: BoxDecoration(
                                                  border: context
                                                              .read<
                                                                  OrdersCubit>()
                                                              .kindOfOrder ==
                                                          "Pending"
                                                      ? const Border(
                                                          bottom: BorderSide(
                                                              color: Color(
                                                                  0xFF3D3D3D),
                                                              width: 1))
                                                      : const Border()),
                                              child: Text(
                                                "Pending",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontFamily: "DM Sans",
                                                    fontSize: 18.sp,
                                                    color: context
                                                                .read<
                                                                    OrdersCubit>()
                                                                .kindOfOrder ==
                                                            "Pending"
                                                        ? const Color(
                                                            0xFF3D3D3D)
                                                        : const Color(
                                                            0xFF9B9B9B),
                                                    shadows: [
                                                      Shadow(
                                                          offset: const Offset(
                                                              0, 4),
                                                          blurRadius: 4,
                                                          color: Colors.black
                                                              .withOpacity(.25))
                                                    ]),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              context
                                                  .read<OrdersCubit>()
                                                  .changeKingOfOrder(
                                                      'Delivered');
                                            },
                                            child: Container(
                                              padding:
                                                  EdgeInsets.only(bottom: 8.h),
                                              width: 150.w,
                                              decoration: BoxDecoration(
                                                  border: context
                                                              .read<
                                                                  OrdersCubit>()
                                                              .kindOfOrder ==
                                                          "Delivered"
                                                      ? const Border(
                                                          bottom: BorderSide(
                                                              color: Color(
                                                                  0xFF3D3D3D),
                                                              width: 1))
                                                      : const Border()),
                                              child: Text(
                                                "Delivered",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontFamily: "DM Sans",
                                                    fontSize: 18.sp,
                                                    color: context
                                                                .read<
                                                                    OrdersCubit>()
                                                                .kindOfOrder ==
                                                            "Delivered"
                                                        ? const Color(
                                                            0xFF3D3D3D)
                                                        : const Color(
                                                            0xFF9B9B9B),
                                                    shadows: [
                                                      Shadow(
                                                          offset: const Offset(
                                                              0, 4),
                                                          blurRadius: 4,
                                                          color: Colors.black
                                                              .withOpacity(.25))
                                                    ]),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: (context
                                                      .read<OrdersCubit>()
                                                      .kindOfOrder ==
                                                  "Pending" &&
                                              pendingOrders.isEmpty) ||
                                          (context
                                                      .read<OrdersCubit>()
                                                      .kindOfOrder !=
                                                  "Pending" &&
                                              deliverdOrders.isEmpty)
                                      ? Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image(
                                              image: AssetImage(context
                                                          .read<OrdersCubit>()
                                                          .kindOfOrder ==
                                                      "Pending"
                                                  ? "assets/images/pending-cart1.png"
                                                  : "assets/images/delivered-cart.png"),
                                              width: 150.w,
                                              height: 150.w,
                                            ),
                                            SizedBox(height: 20.h),
                                            Text(
                                                "There is nothing to be ${context.read<OrdersCubit>().kindOfOrder}.",
                                                style: const TextStyle(
                                                    fontSize: 20)),
                                          ],
                                        )
                                      : Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 25.w),
                                          child: ListView.separated(
                                            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                                            physics:
                                                const BouncingScrollPhysics(),
                                            separatorBuilder:
                                                (context, index) =>
                                                    SizedBox(height: 15.h),
                                            // shrinkWrap: true,
                                            itemCount: context
                                                        .read<OrdersCubit>()
                                                        .kindOfOrder ==
                                                    "Pending"
                                                ? pendingOrders.length
                                                : deliverdOrders.length,
                                            itemBuilder: (context, index) {
                                              return BuildOrderCard(
                                                order: context
                                                            .read<OrdersCubit>()
                                                            .kindOfOrder ==
                                                        "Pending"
                                                    ? pendingOrders[index]
                                                    : deliverdOrders[index],
                                                isDeliverd: context
                                                        .read<OrdersCubit>()
                                                        .kindOfOrder ==
                                                    "Delivered",
                                              );
                                            },
                                          ),
                                        ),
                                )
                              ],
                            ),
                    )
                  : const Center(
                      child: CircularProgressIndicator(color: Colors.black));
            });
      },
    );
  }
}
