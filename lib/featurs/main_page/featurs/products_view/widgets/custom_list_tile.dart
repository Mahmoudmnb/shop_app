import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomListTile extends StatelessWidget {
  final String username;
  final double stars;
  final String date;
  final String description;
  final double width;
  final String? imgUrl;
  const CustomListTile(
      {super.key,
      required this.width,
      required this.username,
      required this.stars,
      required this.date,
      this.imgUrl,
      required this.description});
  Container getLettersOfName() {
    String nameLetters = 'mb';
    var splittedName = username.split(' ');
    nameLetters = splittedName.length >= 2
        ? '${splittedName[0][0].toUpperCase()}${splittedName[splittedName.length - 1][0].toUpperCase()}'
        : splittedName[0][0].toUpperCase();
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey,
      ),
      width: 45.w,
      height: 45.h,
      child: Text(
        nameLetters,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 45.w,
          width: 45.w,
          child: CircleAvatar(
            backgroundColor: const Color(0xFFD9D9D9),
            backgroundImage: imgUrl != null ? AssetImage(imgUrl!) : null,
            child: imgUrl == null ? getLettersOfName() : null,
          ),
        ),
        SizedBox(width: 8.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8.5.h),
            SizedBox(
              width: width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 137.w,
                    child: Text(
                      username,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 13.sp,
                        fontFamily: 'Tenor Sans',
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.20,
                      ),
                    ),
                  ),
                  // !date
                  Text(
                    date,
                    style: TextStyle(
                      color: const Color(0xFF9B9B9B),
                      fontSize: 10.sp,
                      fontFamily: 'Tenor Sans',
                      letterSpacing: 1.20,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 1.h),
            ReviewStars(numOfStars: stars),
            const SizedBox(height: 10),
            SizedBox(
              width: 61.w,
              child: Text(
                description,
                style: const TextStyle(
                  color: Color(0xFF383838),
                  fontSize: 14,
                  fontFamily: 'DM Sans',
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.50,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ],
    );
  }
}

class ReviewStars extends StatelessWidget {
  const ReviewStars({super.key, required this.numOfStars});
  final double numOfStars;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 3.h),
      child: Row(
        children: [
          Icon(
            numOfStars >= 1 ? Icons.star_rounded : Icons.star_border_rounded,
            size: 20.sp,
            color: numOfStars >= 1
                ? const Color(0xFFFFC120)
                : const Color(0xFFC4C5C4),
          ),
          const SizedBox(width: 3),
          Icon(
            numOfStars >= 2 ? Icons.star_rounded : Icons.star_border_rounded,
            size: 20.sp,
            color: numOfStars >= 2
                ? const Color(0xFFFFC120)
                : const Color(0xFFC4C5C4),
          ),
          const SizedBox(width: 3),
          Icon(
            numOfStars >= 3 ? Icons.star_rounded : Icons.star_border_rounded,
            size: 20.sp,
            color: numOfStars >= 3
                ? const Color(0xFFFFC120)
                : const Color(0xFFC4C5C4),
          ),
          const SizedBox(width: 3),
          Icon(
            numOfStars >= 4 ? Icons.star_rounded : Icons.star_border_rounded,
            size: 20.sp,
            color: numOfStars >= 4
                ? const Color(0xFFFFC120)
                : const Color(0xFFC4C5C4),
          ),
          const SizedBox(width: 3),
          Icon(
            numOfStars >= 5 ? Icons.star_rounded : Icons.star_border_rounded,
            size: 20.sp,
            color: numOfStars >= 5
                ? const Color(0xFFFFC120)
                : const Color(0xFFC4C5C4),
          ),
        ],
      ),
    );
  }
}
