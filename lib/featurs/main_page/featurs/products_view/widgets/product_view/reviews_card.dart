import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/core/constant.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../cubits/product_screen/cubit.dart';
import '../../models/review_model.dart';
import '../../screens/product_view_secreens.dart';
import '../product_view_widgets.dart';

class ReviewsCard extends StatelessWidget {
  final ProductCubit cubit;
  final double avrOfStars;
  final Function(List<Map<String, dynamic>> reviews) getAvrOfStars;
  const ReviewsCard(
      {super.key,
      required this.cubit,
      required this.avrOfStars,
      required this.getAvrOfStars});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Review (${cubit.reviws.length})',
              style: TextStyle(
                color: const Color(0xFF0C1A30),
                fontSize: 18.sp,
                fontFamily: 'Tenor Sans',
                fontWeight: FontWeight.bold,
                height: 1.33,
                letterSpacing: 0.20,
              ),
            ),
            Text.rich(
              TextSpan(
                children: [
                  WidgetSpan(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 3),
                      child: Icon(Icons.star,
                          color: const Color(0xFFFFC120), size: 16.sp),
                    ),
                  ),
                  // !here put average of elvaulation
                  TextSpan(
                    text: avrOfStars.toStringAsFixed(2),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontFamily: 'Tenor Sans',
                      letterSpacing: .2,
                      color: const Color(0xFF0C1A30),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 25.5.h),
        //! Cards of reviews
        SizedBox(
          width: 350.w,
          height: cubit.reviws.length >= 3
              ? 325.h
              : cubit.reviws.length == 2
                  ? 255.h
                  : 110.h,
          child: BlocBuilder<ProductCubit, ProductStates>(
            builder: (context, state) {
              List<Map<String, dynamic>> reviews = cubit.reviws;
              if (state is GetReviews) {
                reviews = cubit.reviws;
                getAvrOfStars(reviews);
              }
              return ListView.builder(
                itemCount: reviews.length < 3 ? reviews.length : 3,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  ReviewModel review = ReviewModel.fromMap(reviews[index]);
                  return CustomListTile(
                    //* this width (100% - 120px) becasue this card has a custom padding :)
                    //* (bannan don't kill me please ^_^)
                    width: 295.w,
                    username: review.userName,
                    date: getOffsetDate(review.date),
                    description: review.description,
                    stars: review.stars,
                    imgUrl: review.userImage,
                  );
                },
              );
            },
          ),
        ),

        SizedBox(height: 25.5.h),
        //* this widget was a SizedBox Widget and I convert it to Contianer 
        //* add a margin property instead of Padding(child: SizedBox(...))
        Container(
          //* I use margin to put the button in the center of page 
          //* to make the button so beautiful
          margin: EdgeInsets.only(right: 10.w),
          width: 393.w,
          height: 50.h,
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => AllReviewsScreen(reviews: cubit.reviws),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
                elevation: 0,
                shape: const RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    color: Color(0xFF0C1A30),
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                foregroundColor: const Color(0xFF0C1A30),
                backgroundColor: const Color(0xFFFFFFFF)),
            child: Text(
              'See All Review',
              style: TextStyle(
                color: const Color(0xFF0C1A30),
                fontSize: 16.sp,
                fontFamily: 'DM Sans',
                fontWeight: FontWeight.w500,
                height: 1.43,
              ),
            ),
          ),
        ),
      ],
    );
  }

  String getOffsetDate(String date) {
    DateTime dateTime = Constant.stringToDate(date);
    DateTime currentDatetime = DateTime.now();
    if (dateTime.year != currentDatetime.year) {
      return '${currentDatetime.year - dateTime.year} year ago';
    } else if (dateTime.month != currentDatetime.month) {
      return '${currentDatetime.month - dateTime.month} month ago';
    } else if (dateTime.day != currentDatetime.day) {
      return '${currentDatetime.day - dateTime.day} days ago';
    } else if (dateTime.hour != currentDatetime.hour) {
      return '${currentDatetime.hour - dateTime.hour} hours ago';
    } else {
      return '${currentDatetime.minute - dateTime.minute} minute ago';
    }
  }
}
