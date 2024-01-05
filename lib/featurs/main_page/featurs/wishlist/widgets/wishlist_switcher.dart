import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../bloc/wishlist_cubit.dart';

class WishlistSwitcher extends StatelessWidget {
  const WishlistSwitcher({super.key, required this.text1, required this.text2});
  final String text1, text2;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WishlistCubit, WishlistState>(
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      context.read<WishlistCubit>().changeKingOfOrder(text1);
                    },
                    child: Container(
                      padding: EdgeInsets.only(bottom: 8.h),
                      width: 150.w,
                      decoration: BoxDecoration(
                          border:
                              context.read<WishlistCubit>().kindOfOrder == text1
                                  ? const Border(
                                      bottom: BorderSide(
                                          color: Color(0xFF3D3D3D), width: 1))
                                  : const Border()),
                      child: Text(
                        text1,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: "DM Sans",
                            fontSize: 18.sp,
                            color: context.read<WishlistCubit>().kindOfOrder ==
                                    text1
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
                      context.read<WishlistCubit>().changeKingOfOrder(text2);
                    },
                    child: Container(
                      padding: EdgeInsets.only(bottom: 8.h),
                      width: 150.w,
                      decoration: BoxDecoration(
                          border:
                              context.read<WishlistCubit>().kindOfOrder == text2
                                  ? const Border(
                                      bottom: BorderSide(
                                          color: Color(0xFF3D3D3D), width: 1))
                                  : const Border()),
                      child: Text(
                        text2,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "DM Sans",
                          fontSize: 18.sp,
                          color:
                              context.read<WishlistCubit>().kindOfOrder == text2
                                  ? const Color(0xFF3D3D3D)
                                  : const Color(0xFF9B9B9B),
                          shadows: [
                            Shadow(
                                offset: const Offset(0, 4),
                                blurRadius: 4,
                                color: Colors.black.withOpacity(.25))
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
