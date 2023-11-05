import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shop_app/featurs/auth/pages/steper_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashScreen extends StatefulWidget {
  final double deviceHeight;
  final double deviceWidth;
  const SplashScreen({
    super.key,
    required this.deviceWidth,
    required this.deviceHeight,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double height = 0;
  int duraton = 700;
  double logoWidth = 15.w;
  double logoHeight = 15.w;
  double opacity = 0;
  Color color = Colors.grey;
  @override
  void initState() {
    start();
    super.initState();
  }

  void start() {
    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      height = widget.deviceHeight * 0.6;
      timer.cancel();
      setState(() {});
    });
    Timer.periodic(const Duration(milliseconds: 1400), (timer) {
      height = widget.deviceHeight * 0.4;
      color = Colors.transparent;
      timer.cancel();
      setState(() {});
    });
    Timer.periodic(const Duration(milliseconds: 1800), (timer) {
      height = widget.deviceHeight * 0.5;
      logoWidth = widget.deviceWidth * 0.8;
      logoHeight = widget.deviceHeight * 0.08;
      opacity = 1;
      timer.cancel();
      setState(() {});
    });
    Timer.periodic(const Duration(milliseconds: 2800), (timer) {
      Navigator.of(context).pushReplacement(PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 1200),
          pageBuilder: (context, animation, secondaryAnimation) {
            Animation<Offset> offset = Tween<Offset>(
                    begin: const Offset(1, 0), end: const Offset(0, 0))
                .animate(animation);
            return SlideTransition(
                position: offset, child: const SteperScreen());
          }));
      timer.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [
                0.6,
                1
              ],
                  colors: [
                const Color(0xffFFEAD7),
                Colors.black.withOpacity(0.3)
              ])),
          child: Column(
            children: [
              AnimatedContainer(
                height: height,
                duration: Duration(milliseconds: duraton),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                padding: const EdgeInsets.all(5),
                width: logoWidth,
                height: logoHeight,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                    color: color, borderRadius: BorderRadius.circular(50)),
                child: logoWidth == 80
                    ? null
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 500),
                          opacity: opacity,
                          child: Image.asset(
                            'assets/images/splash_logo.png',
                            height: 80,
                            width: widget.deviceWidth * 0.78,
                            fit: BoxFit.contain,
                          ),
                        )),
              )
            ],
          )),
    );
  }
}
