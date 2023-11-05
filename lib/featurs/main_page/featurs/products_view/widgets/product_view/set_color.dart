import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../cubits/product_screen/cubit.dart';

class SetColor extends StatelessWidget {
  const SetColor({super.key, required this.colors});
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductCubit, ProductStates>(
      listener: (context, state) {},
      builder: (context, state) {
        ProductCubit cubit = BlocProvider.of<ProductCubit>(context);
        return ScreenUtilInit(
          designSize: const Size(393, 852),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => InkWell(
              onTap: () {
                cubit.changeIndexOfColor(index);
              },
              child: Container(
                alignment: Alignment.center,
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: colors[index],
                  borderRadius: BorderRadius.circular(22 / 2),
                ),
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(18 / 2)),
                      side: cubit.indexOfColor == index
                          ? const BorderSide(color: Colors.white, width: 1)
                          : BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
            separatorBuilder: (context, index) =>  SizedBox(width: 15.w),
            itemCount: colors.length,
          ),
        );
      },
    );
  }
}
