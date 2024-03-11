import 'package:flutter/material.dart';
import 'package:shop_app/featurs/auth/pages/auth_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SteperScreen extends StatefulWidget {
  const SteperScreen({super.key});

  @override
  State<SteperScreen> createState() => _SteperScreenState();
}

class _SteperScreenState extends State<SteperScreen> {
  late PageController pageController;
  @override
  void initState() {
    pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        PageView(
          controller: pageController,
          children: [
            Container(
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 20.h),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: ResizeImage(
                        height: MediaQuery.of(context).size.height.toInt(),
                        width: MediaQuery.of(context).size.width.toInt(),
                        const AssetImage('assets/images/splash1.jpg'),
                      ),
                      fit: BoxFit.cover)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Have a charming  look!',
                      style: TextStyle(
                          fontFamily: 'Tiro Gurmukhi',
                          color: Colors.white,
                          fontSize: 32.sp)),
                  const SizedBox(height: 15),
                  Text(
                      'Step into a world of timeless style and unparalleled sophistication with our application',
                      style: TextStyle(
                          fontFamily: 'Bentham',
                          color: Colors.white,
                          fontSize: 24.sp)),
                  SizedBox(height: 100.h),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            navigateToAuthPage(context);
                          },
                          style: ButtonStyle(
                              padding: const MaterialStatePropertyAll(
                                  EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 5)),
                              backgroundColor: MaterialStatePropertyAll(
                                  const Color(0xffB3B3B3).withOpacity(0.31))),
                          child: Text('Skip',
                              style: TextStyle(
                                  fontFamily: 'Bentham',
                                  color: Colors.white.withOpacity(0.73),
                                  fontSize: 27.sp)),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            pageController.animateToPage(1,
                                duration: const Duration(milliseconds: 1000),
                                curve: Curves.ease);
                          },
                          style: ButtonStyle(
                              padding: const MaterialStatePropertyAll(
                                  EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 5)),
                              backgroundColor: MaterialStatePropertyAll(
                                  const Color(0xffB3B3B3).withOpacity(0.31))),
                          child: Text(
                            'Next',
                            style: TextStyle(
                                fontFamily: 'Bentham',
                                color: Colors.white.withOpacity(0.73),
                                fontSize: 27.sp),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 6.h),
              decoration:  BoxDecoration(
                  image: DecorationImage(
                      image: ResizeImage(
                        height: MediaQuery.of(context).size.height.toInt(),
                        width: MediaQuery.of(context).size.width.toInt(),
                        const AssetImage('assets/images/splash2.jpg'),
                      ),
                      fit: BoxFit.cover)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Find your perfect style',
                      style: TextStyle(
                          fontFamily: 'Tiro Gurmukhi',
                          color: Colors.white,
                          fontSize: 32.sp)),
                  const SizedBox(height: 15),
                  Text(
                    'With a huge collection of elegant clothes, you must find what you need',
                    style: TextStyle(
                        fontFamily: 'Bentham',
                        color: Colors.white,
                        fontSize: 24.sp),
                  ),
                  SizedBox(height: 120.h),
                  Padding(
                    padding: EdgeInsets.only(bottom: 50.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            navigateToAuthPage(context);
                          },
                          style: ButtonStyle(
                              padding: const MaterialStatePropertyAll(
                                  EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 5)),
                              backgroundColor: MaterialStatePropertyAll(
                                  const Color(0xffB3B3B3).withOpacity(0.31))),
                          child: Text('Let’s start',
                              style: TextStyle(
                                  fontFamily: 'Bentham',
                                  color: Colors.white.withOpacity(0.73),
                                  fontSize: 32.sp)),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        Positioned(
            bottom: 130.h,
            left: 160.w,
            child: SmoothPageIndicator(controller: pageController, count: 2))
      ]),
    );
  }

  void navigateToAuthPage(BuildContext context) {
    Navigator.of(context).pushReplacement(PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) {
          Animation<Offset> offset =
              Tween<Offset>(begin: const Offset(1, 0), end: const Offset(0, 0))
                  .animate(animation);
          return SlideTransition(position: offset, child: const AuthPage());
        }));
  }
}
