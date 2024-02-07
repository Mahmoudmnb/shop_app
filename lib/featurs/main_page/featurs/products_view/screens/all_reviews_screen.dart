import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop_app/core/constant.dart';

import '../models/review_model.dart';
import '../widgets/product_view_widgets.dart';

class AllReviewsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> reviews;
  const AllReviewsScreen({super.key, required this.reviews});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 25.h),
            Padding(
              padding: EdgeInsets.only(left: 20.w),
              child: Row(
                children: [
                  CustomIconButton(
                    icon: const Icon(Icons.arrow_back_ios_rounded),
                    onPressed: () {
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                  SizedBox(width: 20.w),
                  Text(
                    'All Reviews',
                    style: TextStyle(
                      color: const Color(0xFF171717),
                      fontSize: 24.sp,
                      fontFamily: 'Tenor Sans',
                      fontWeight: FontWeight.w600,
                      height: 1.06,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.only(left: 75.0.w),
              child: Text(
                '${reviews.length} Review',
                style: TextStyle(
                  color: const Color(0xFF979797),
                  fontSize: 16.sp,
                  fontFamily: 'Tenor Sans',
                  fontWeight: FontWeight.w400,
                  height: 1.06,
                  letterSpacing: 1,
                ),
              ),
            ),
            SizedBox(height: 25.5.h),
            reviews.isEmpty
                ? Container(
                    padding: EdgeInsets.symmetric(vertical: 50.h),
                    width: double.infinity,
                    child: Column(
                      children: [
                        Image(
                          height: 200.h,
                          image: const AssetImage('assets/icons/noReveiws.png'),
                        ),
                        SizedBox(
                          height: 25.h,
                        ),
                        Text(
                          "No reviews published",
                          style: TextStyle(
                              fontSize: 18.sp, color: Colors.grey[600]),
                        )
                      ],
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: reviews.length,
                      itemBuilder: (context, index) {
                        ReviewModel review =
                            ReviewModel.fromMap(reviews[index]);
                        return Padding(
                          padding: EdgeInsets.only(
                              left: 30.w, right: 30.w, bottom: 15.h),
                          child: CustomListTile(
                            width: 273.w,
                            username: review.userName,
                            date: getOffsetDate(review.date),
                            description: review.description,
                            stars: review.stars,
                            imgUrl: review.userImage,
                          ),
                        );
                      },
                    ),
                  )
          ],
        ),
      ),
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
    } else if (dateTime.minute != currentDatetime.minute) {
      return '${currentDatetime.minute - dateTime.minute} minute ago';
    } else {
      return '${currentDatetime.second - dateTime.second} seconds ago';
    }
  }
}
