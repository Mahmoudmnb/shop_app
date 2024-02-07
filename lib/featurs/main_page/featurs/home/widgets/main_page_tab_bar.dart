import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainPageTabBar extends StatelessWidget {
  final TabController tabController;
  const MainPageTabBar({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52.h,
      width: 393.w,
      decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.grey, offset: Offset(0, -1), blurRadius: 10),
            BoxShadow(color: Colors.white, offset: Offset(0, 0)),
          ],
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      child: TabBar(
          onTap: (value) {
            if (tabController.index == 3) {
              tabController.index = 0;
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 10.h),
                        content: SizedBox(
                            height: 230.h,
                            child: Column(
                              children: [
                                SizedBox(height: 10.h),
                                Text(
                                  "You have to resign",
                                  style: TextStyle(
                                      fontSize: 18.sp,
                                      fontFamily: 'DM Sans',
                                      color: Colors.grey[1000]),
                                ),
                                SizedBox(height: 30.h),
                                Image(
                                    height: 100.h,
                                    color: Colors.grey[600],
                                    image: const AssetImage(
                                      'assets/icons/needsign.png',
                                    )),
                                Row(
                                  children: [
                                    const Spacer(),
                                    MaterialButton(
                                        onPressed: () {},
                                        child: Text(
                                          "Sign Up",
                                          style: TextStyle(
                                              fontSize: 18.sp,
                                              fontFamily: 'DM Sans',
                                              color: Colors.grey[1000]),
                                        ))
                                  ],
                                )
                              ],
                            )),
                      ));
            }
          },
          padding: const EdgeInsets.all(5),
          unselectedLabelColor: const Color(0xffC5C5C5),
          indicatorColor: Colors.transparent,
          labelColor: Colors.black,
          controller: tabController,
          tabs: const [
            Icon(Icons.home),
            Icon(Icons.search),
            Icon(Icons.shopping_basket_rounded),
            Icon(Icons.person)
          ]),
    );
  }
}
