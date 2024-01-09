import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop_app/core/constant.dart';

import '../../../cubit/main_page_cubit.dart';
import '../../orders/screen/orders_screen.dart';
import 'personal_details_screen.dart';
import 'shopping_address.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<MainPageCubit>().changePageIndex(3);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Constant.currentUser == null
          ? const Center(child: Text('You have to register'))
          : SingleChildScrollView(
              child: SizedBox(
                width: double.infinity,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 80.h),
                      BlocBuilder<MainPageCubit, MainPageState>(
                        builder: (context, state) {
                          return Column(
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(12)),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Constant.currentUser!.imgUrl == null
                                        ? Image(
                                            fit: BoxFit.cover,
                                            height: 100.h,
                                            width: 100.h,
                                            image: const AssetImage(
                                                'assets/icons/UnknownPerson.jpeg'))
                                        : Image(
                                            fit: BoxFit.cover,
                                            height: 100.h,
                                            width: 100.h,
                                            image: FileImage(File(Constant
                                                .currentUser!.imgUrl!))),
                                  )),
                              SizedBox(height: 8.h),
                              Text(
                                Constant.currentUser!.name,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.sp),
                              ),
                            ],
                          );
                        },
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 24.w, vertical: 24.h),
                        padding: EdgeInsets.symmetric(vertical: 15.h),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                width: 1, color: const Color(0xFFC9C9C9))),
                        child: Column(children: [
                          buildListTile(
                            context,
                            "assets/images/proficon.png",
                            "Personal Details",
                            () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(
                                builder: (context) => const PersonalDetails(),
                              ))
                                  .then((value) {
                                context
                                    .read<MainPageCubit>()
                                    .updateProfilePageData();
                              });
                            },
                          ),
                          buildListTile(
                            context,
                            "assets/images/Frame.png",
                            "Shopping Address",
                            () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const ShoppingAddress(),
                              ));
                            },
                          ),
                          buildListTile(
                            context,
                            "assets/images/card.png",
                            "My Card",
                            () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const ShoppingAddress(),
                              ));
                            },
                          ),
                          buildListTile(
                            context,
                            "assets/images/bag.png",
                            "My Order",
                            () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const MyOrdersScreen(),
                              ));
                            },
                          ),
                          buildListTile(
                            context,
                            "assets/images/Favorite_fill.png",
                            "My Wishlist",
                            () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const MyOrdersScreen(),
                              ));
                            },
                          ),
                          buildListTile(
                            context,
                            "assets/images/star.png",
                            "Rate this app",
                            () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const MyOrdersScreen(),
                              ));
                            },
                          ),
                        ]),
                      ),
                      SizedBox(height: 3.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30.w),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () {},
                          child: Ink(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 15.h),
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(10)),
                            child: const Text(
                              "Log Out",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "DM Sans"),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 12.h),
                    ]),
              ),
            ),
    );
  }

  Widget buildListTile(
      BuildContext context, String url, String title, Function() ontap) {
    return ListTile(
      onTap: ontap,
      leading: Container(
        decoration: BoxDecoration(
            color: const Color(0xFFECECEC),
            borderRadius: BorderRadius.circular(6)),
        padding: const EdgeInsets.all(10),
        child: Image(height: 15.h, width: 15.h, image: AssetImage(url)),
      ),
      title: Container(
        padding: EdgeInsets.only(left: 20.w),
        child: Text(
          title,
          style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold),
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 15),
    );
  }
}
