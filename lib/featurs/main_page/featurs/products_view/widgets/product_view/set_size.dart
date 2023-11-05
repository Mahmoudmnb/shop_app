import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/product_screen/cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class SetSize extends StatelessWidget {
  const SetSize({super.key, required this.sizes});
  final List<String> sizes;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductCubit, ProductStates>(
      listener: (context, state) {},
      builder: (context, state) {
        ProductCubit cubit = BlocProvider.of<ProductCubit>(context);
        return ListView.separated(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) => InkWell(
            onTap: () {
              cubit.changeIndexOfSize(index);
            },
            child: Container(
              alignment: Alignment.center,
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: cubit.indexOfSize == index
                    ? const Color(0xFF33302E)
                    : const Color(0xFFE7E7E7),
                borderRadius: BorderRadius.circular(22 / 2),
              ),
              child: Text(
                sizes[index],
                style: TextStyle(
                  color:
                      cubit.indexOfSize == index ? Colors.white : Colors.black,
                  fontSize: 10,
                  fontFamily: 'Tenor Sans',
                  fontWeight: FontWeight.w400,
                  letterSpacing: -0.30,
                ),
              ),
            ),
          ),
          separatorBuilder: (context, index) =>  SizedBox(width: 15.w),
          itemCount: sizes.length,
        );
      },
    );
  }
}
