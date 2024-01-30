import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop_app/core/constant.dart';
import 'package:shop_app/featurs/auth/pages/auth_page.dart';
import 'package:shop_app/featurs/main_page/data_source/data_source.dart';
import 'package:shop_app/featurs/main_page/featurs/orders/cubit/orders_cubit.dart';
import 'package:shop_app/featurs/main_page/featurs/orders/screen/rate_order.dart';
import 'package:shop_app/featurs/main_page/featurs/profile/cubit/profile_cubit.dart';
import 'package:shop_app/featurs/main_page/featurs/profile/screen/profile_order_screen.dart';
import 'package:shop_app/featurs/main_page/featurs/shopping_bag/screens/shopping_bag_screen.dart';
import 'package:shop_app/featurs/main_page/featurs/wishlist/screens/wishlist_screen.dart';
import 'package:shop_app/injection.dart';
import 'package:toast/toast.dart';

import '../../../../../core/internet_info.dart';
import '../../../cubit/main_page_cubit.dart';
import 'personal_details_screen.dart';
import 'shopping_address.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    context.read<MainPageCubit>().changePageIndex(3);
    if (Constant.currentUser != null) {
      context.read<ProfileCubit>().profileImagePath =
          Constant.currentUser!.imgUrl;
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: Constant.currentUser == null
          ? Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('You have to register'),
                TextButton(
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                              builder: (_) => const AuthPage()))
                          .then((value) {
                        setState(() {});
                      });
                    },
                    child: const Text('Register now'))
              ],
            ))
          : SingleChildScrollView(
              child: SizedBox(
                width: double.infinity,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 60.h),
                      BlocBuilder<ProfileCubit, ProfileState>(
                        builder: (context, state) {
                          return Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(12)),
                                child: context
                                            .read<ProfileCubit>()
                                            .profileImagePath ==
                                        null
                                    ? SizedBox(
                                        height: 100.h,
                                        width: 100.h,
                                        child: Center(
                                            child: Text(
                                          Constant.getLetterName(
                                              Constant.currentUser!.name),
                                          style: TextStyle(
                                              fontSize: 30.sp,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 2,
                                              color: Colors.white),
                                        )),
                                      )
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image(
                                            fit: BoxFit.cover,
                                            height: 100.h,
                                            width: 100.h,
                                            image: FileImage(File(context
                                                .read<ProfileCubit>()
                                                .profileImagePath!))),
                                      ),
                              ),
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
                                // context
                                //     .read<MainPageCubit>()
                                //     .updateProfilePageData();
                              });
                            },
                          ),
                          buildListTile(
                            context,
                            "assets/images/Frame.png",
                            "Shopping Address",
                            () async {
                              List<Map<String, dynamic>> addressList =
                                  await sl.get<DataSource>().getLocations();
                              if (context.mounted) {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ShoppingAddress(
                                    addressList: addressList,
                                  ),
                                ));
                              }
                            },
                          ),
                          buildListTile(
                            context,
                            "assets/images/card.png",
                            "My Cart",
                            () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => const ShoppingBagScreen()));
                            },
                          ),
                          buildListTile(
                            context,
                            "assets/images/bag.png",
                            "My Order",
                            () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    const ProfileOrderScreen(),
                              ));
                            },
                          ),
                          buildListTile(
                            context,
                            "assets/images/Favorite_fill.png",
                            "My Wishlist",
                            () async {
                              List<Map<String, dynamic>> borders =
                                  await sl.get<DataSource>().getBorders();
                              if (context.mounted) {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => WishListScreen(
                                    borders: borders,
                                  ),
                                ));
                              }
                            },
                          ),
                          buildListTile(
                            context,
                            "assets/images/star.png",
                            "Rate this app",
                            () {
                              context.read<OrdersCubit>().changeRating(0);
                              context.read<OrdersCubit>().opinionController =
                                  TextEditingController();
                              context.read<OrdersCubit>().character = 50;
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => const RatePage()));
                            },
                          ),
                        ]),
                      ),
                      SizedBox(height: 3.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30.w),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () async {
                            if (!context.read<ProfileCubit>().isLogOutLoading) {
                              context
                                  .read<ProfileCubit>()
                                  .setIsLogOutLoading(true);
                              InternetInfo.isconnected().then((value) async {
                                if (value) {
                                  await context.read<ProfileCubit>().logOut();
                                  if (context.mounted) {
                                    context
                                        .read<ProfileCubit>()
                                        .setIsLogOutLoading(false);
                                    Constant.currentUser = null;
                                    setState(() {});
                                  }
                                } else {
                                  context
                                      .read<ProfileCubit>()
                                      .setIsLogOutLoading(false);
                                  ToastContext().init(context);
                                  Toast.show('Check your internet connection',
                                      duration: Toast.lengthLong);
                                }
                              });
                            }
                          },
                          child: Ink(
                            height: 65.h,
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 15.h),
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(10)),
                            child: BlocBuilder<ProfileCubit, ProfileState>(
                              builder: (context, state) {
                                return context
                                        .read<ProfileCubit>()
                                        .isLogOutLoading
                                    ? const Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      )
                                    : Text(
                                        "Log Out",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.sp,
                                            fontFamily: "DM Sans"),
                                      );
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
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
