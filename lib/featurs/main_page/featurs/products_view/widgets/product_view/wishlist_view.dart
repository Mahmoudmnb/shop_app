import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop_app/featurs/main_page/featurs/products_view/widgets/product_view/wishlist_border.dart';

class WishlistView extends StatelessWidget {
  const WishlistView({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 513.h,
      child: Column(
        children: [
          SizedBox(height: 20.h),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: const Color(0xFFDFDFDF),
            ),
            width: 70.w,
            height: 4.5.h,
          ),
          SizedBox(height: 30.h),
          Padding(
            padding: EdgeInsets.only(left: 25.w, right: 25.w),
            child: SizedBox(
              height: 60.w,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    child: Image(
                      image: const AssetImage('assets/images/11.jpg'),
                      fit: BoxFit.cover,
                      width: 60.w,
                      height: 60.w,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 3.h),
                      const Text(
                        'Added To Wishlist',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'DM Sans',
                          fontWeight: FontWeight.w400,
                          height: 1.06,
                          letterSpacing: 1,
                        ),
                      ),
                      SizedBox(height: 7.h),
                      const Text(
                        'All items',
                        style: TextStyle(
                          color: Color(0xFFEEEEEE),
                          fontSize: 10,
                          fontFamily: 'DM Sans',
                          fontWeight: FontWeight.w400,
                          height: 1.06,
                          letterSpacing: 1,
                        ),
                      ),
                      SizedBox(height: 3.h),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    children: [
                      const Spacer(),
                      Icon(
                        Icons.favorite,
                        color: const Color(0xFFF8F7F7),
                        size: 30.sp,
                      ),
                      const Spacer(),
                    ],
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 15.h),
          Expanded(
            child: Container(
              color: const Color(0xFF383838),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 25.w, right: 22.w),
                    child: Column(
                      children: [
                        SizedBox(height: 15.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Borders',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: 'DM Sans',
                                fontWeight: FontWeight.w500,
                                height: 1.06,
                                letterSpacing: 1,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    shape: const OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      borderSide: BorderSide.none,
                                    ),
                                    backgroundColor: const Color(0xFF383838),
                                    title: SizedBox(
                                      width: 300.w,
                                      child: const Center(
                                          child: Text(
                                        'Border Name',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontFamily: 'DM Sans',
                                          fontWeight: FontWeight.w400,
                                          height: 1.06,
                                          letterSpacing: 1,
                                        ),
                                      )),
                                    ),
                                    content: TextFormField(
                                      cursorColor: Colors.grey,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontFamily: 'DM Sans',
                                        letterSpacing: 1,
                                      ),
                                      decoration: const InputDecoration(
                                        
                                        filled: true,
                                        fillColor: Color(0xFF5A5A5A),
                                        hintText: 'Border Name',
                                        hintStyle:
                                            TextStyle(color: Colors.white),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            borderSide: BorderSide.none),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            borderSide: BorderSide.none),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              style: TextButton.styleFrom(
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                foregroundColor: const Color(0xFF689FD1),
                              ),
                              child: const Text(
                                'New Border',
                                style: TextStyle(
                                  color: Color(0xFF689FD1),
                                  fontSize: 13,
                                  fontFamily: 'DM Sans',
                                  fontWeight: FontWeight.w500,
                                  height: 1.06,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(
                          decelerationRate: ScrollDecelerationRate.fast),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          //! here is the list of borders
                          children: List.generate(
                            5,
                            (index) => Padding(
                              padding: EdgeInsets.only(
                                  left: 25.w, right: 22.w, bottom: 15.h),
                              child: const WishlistBorder(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // ListView(shrinkWrap: true,)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
