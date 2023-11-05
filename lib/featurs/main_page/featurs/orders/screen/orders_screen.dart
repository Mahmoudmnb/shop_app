import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../cubit/main_page_cubit.dart';
import '../cubit/orders_cubit.dart';
import '../model/card_model.dart';
import '../widgets/order_card.dart';

class MyOrdersScreen extends StatelessWidget {
  const MyOrdersScreen({super.key});
  @override
  Widget build(BuildContext context) {
    List<CardModel> pending = [
      CardModel(
          kingOfOrder: 'Pending',
          quantity: 2,
          subtotal: 40,
          trackingNumber: 'lskfdlsj',
          numb: '1580',
          orderDate: DateTime(2023, 9, 2),
          dueDate: DateTime(2023, 9, 20)),
      CardModel(
          kingOfOrder: 'Pending',
          quantity: 2,
          subtotal: 40,
          trackingNumber: 'lskfdlsj',
          numb: '1580',
          orderDate: DateTime(2023, 9, 2),
          dueDate: DateTime(2023, 9, 20)),
      //lsdkfj
      CardModel(
          kingOfOrder: 'Pending',
          quantity: 2,
          subtotal: 40,
          trackingNumber: 'lskfdlsj',
          numb: '1580',
          orderDate: DateTime(2023, 9, 2),
          dueDate: DateTime(2023, 9, 20))
    ];
    List<CardModel> delivered = [
      CardModel(
          kingOfOrder: 'Delivered',
          quantity: 2,
          subtotal: 40,
          trackingNumber: 'lskfdlsj',
          numb: '1580',
          orderDate: DateTime(2023, 9, 2),
          dueDate: DateTime(2023, 9, 20)),
      CardModel(
          kingOfOrder: 'Delivered',
          quantity: 2,
          subtotal: 40,
          trackingNumber: 'lskfdlsj',
          numb: '1580',
          orderDate: DateTime(2023, 9, 2),
          dueDate: DateTime(2023, 9, 20)),
      CardModel(
          kingOfOrder: 'Delivered',
          quantity: 2,
          subtotal: 40,
          trackingNumber: 'lskfdlsj',
          numb: '1580',
          orderDate: DateTime(2023, 9, 2),
          dueDate: DateTime(2023, 9, 20)),
      CardModel(
          kingOfOrder: 'Delivered',
          quantity: 2,
          subtotal: 40,
          trackingNumber: 'lskfdlsj',
          numb: '1580',
          orderDate: DateTime(2023, 9, 2),
          dueDate: DateTime(2023, 9, 20)),
    ];
    return BlocConsumer<OrdersCubit, OrdersState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = OrdersCubit.get(context);
        context.read<MainPageCubit>().changePageIndex(2);
        return Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: Column(
                  children: [
                    const Divider(),
                    SizedBox(
                      height: 8.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            cubit.changeKingOfOrder('Pending');
                          },
                          child: Container(
                            padding: EdgeInsets.only(bottom: 8.h),
                            width: 150.w,
                            decoration: BoxDecoration(
                                border: cubit.kindOfOrder == "Pending"
                                    ? const Border(
                                        bottom: BorderSide(
                                            color: Color(0xFF3D3D3D), width: 1))
                                    : const Border()),
                            child: Text(
                              "Pending",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: "DM Sans",
                                  fontSize: 18.sp,
                                  color: cubit.kindOfOrder == "Pending"
                                      ? const Color(0xFF3D3D3D)
                                      : const Color(0xFF9B9B9B),
                                  shadows: [
                                    Shadow(
                                        offset: const Offset(0, 4),
                                        blurRadius: 4,
                                        color: Colors.black.withOpacity(.25))
                                  ]),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            cubit.changeKingOfOrder('Delivered');
                          },
                          child: Container(
                            padding: EdgeInsets.only(bottom: 8.h),
                            width: 150.w,
                            decoration: BoxDecoration(
                                border: cubit.kindOfOrder == "Delivered"
                                    ? const Border(
                                        bottom: BorderSide(
                                            color: Color(0xFF3D3D3D), width: 1))
                                    : const Border()),
                            child: Text(
                              "Delivered",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: "DM Sans",
                                  fontSize: 18.sp,
                                  color: cubit.kindOfOrder == "Delivered"
                                      ? const Color(0xFF3D3D3D)
                                      : const Color(0xFF9B9B9B),
                                  shadows: [
                                    Shadow(
                                        offset: const Offset(0, 4),
                                        blurRadius: 4,
                                        color: Colors.black.withOpacity(.25))
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
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    separatorBuilder: (context, index) => SizedBox(
                      height: 15.h,
                    ),
                    // shrinkWrap: true,
                    itemCount: cubit.kindOfOrder == "Pending"
                        ? pending.length
                        : delivered.length,
                    itemBuilder: (context, index) => BuildOrderCard(
                        card: cubit.kindOfOrder == "Pending"
                            ? pending[index]
                            : delivered[index]),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
