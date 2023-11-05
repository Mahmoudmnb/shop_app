import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../cubit/sreach_cubit.dart';

class PopularSearch extends StatelessWidget {
  final SearchCubit cubit;
  const PopularSearch({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Text(
            "Popular search",
            style: TextStyle(
                color: const Color(0xFF888888),
                fontSize: 18.sp,
                fontFamily: 'DM Sans'),
          ),
        ),
        SizedBox(height: 15.h),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: 6,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 1.5.sp,
            crossAxisSpacing: 10.w,
          ),
          itemBuilder: (context, index) => Center(
            child: Container(
              width: 75.w,
              height: 26.h,
              decoration: BoxDecoration(
                  color: const Color(0xFFF0EFEF),
                  borderRadius: BorderRadius.circular(3)),
              child: const Center(child: Text("Trendy")),
            ),
          ),
        ),
      ],
    );
  }
}
