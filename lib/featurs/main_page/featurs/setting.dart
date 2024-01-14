import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 60.h),
        child: Column(children: [
          Row(
            children: [
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Image(
                    height: 40.w,
                    width: 40.w,
                    image: const AssetImage("assets/images/backicon.png"),
                  )),
              SizedBox(width: 10.w),
              Text(
                "Setting",
                style: TextStyle(fontSize: 18.sp, fontFamily: 'Tenor Sans'),
              )
            ],
          ),
          SizedBox(
            height: 30.h,
          ),
          buildListTile(
              title: 'Language',
              url: "assets/images/language.png",
              ontap: () {}),
          buildListTile(
              title: 'Terms of Use',
              url: "assets/images/terms.png",
              ontap: () {}),
          buildListTile(
              title: 'Pricavy Policy',
              url: "assets/images/policy.png",
              ontap: () {}),
          buildListTile(
              title: 'Chat support',
              url: "assets/images/support.png",
              ontap: () {}),
        ]),
      ),
    );
  }

  Widget buildListTile(
      {required String title, required String url, required Function ontap}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Row(
        children: [
          Image(height: 30.h, width: 30.h, image: AssetImage(url)),
          Container(
            padding: EdgeInsets.only(left: 15.w),
            child: Text(
              title,
              style: TextStyle(
                  fontSize: 15.sp,
                  fontFamily: 'DM Sans',
                  fontWeight: FontWeight.bold),
            ),
          ),
          const Spacer(),
          const Icon(
            Icons.arrow_forward_ios,
            size: 15,
          ),
        ],
      ),
    );
  }
}
