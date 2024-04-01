import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';

import '../../../../../core/constant.dart';
import '../../../../../core/internet_info.dart';
import '../../../../../injection.dart';
import '../../../../auth/pages/auth_pages.dart';
import '../../../data_source/data_source_paths.dart';
import '../../orders/cubit/orders_cubit.dart';
import '../../orders/screen/rate_order.dart';
import '../../shopping_bag/cubits/products_cubit/products_cubit.dart';
import '../../shopping_bag/screens/shopping_bag_screen.dart';
import '../../wishlist/screens/wishlist_screen.dart';
import '../cubit/profile_cubit.dart';
import 'personal_details_screen.dart';
import 'profile_order_screen.dart';
import 'shopping_address.dart';

class ProfileScreen extends StatefulWidget {
  final ProfileCubit profileCubit;
  final PageController pageController;
  final TabController tabController;
  const ProfileScreen(
      {super.key,
      required this.profileCubit,
      required this.pageController,
      required this.tabController});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ProfileCubit profileCubit;
  @override
  void initState() {
    profileCubit = widget.profileCubit;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    if (Constant.currentUser != null) {
      profileCubit.profileImagePath = Constant.currentUser!.imgUrl;
    }
    return Scaffold(
        backgroundColor: Colors.white,
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            return Constant.currentUser == null
                ? Padding(
                    padding: EdgeInsets.only(bottom: 30.h),
                    child: Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          image: ResizeImage(
                              width: 300.w.toInt(),
                              height: 300.w.toInt(),
                              const AssetImage('assets/images/lock.png')),
                        ),
                        TextButton(
                            onPressed: () async {
                              await Navigator.of(context)
                                  .push(MaterialPageRoute(
                                      builder: (_) => const AuthPage(
                                            fromPage: 'Profile',
                                          )));
                              // setState(() {});
                            },
                            child: Text(
                              'Register now',
                              style: TextStyle(fontSize: 20.sp),
                            ))
                      ],
                    )),
                  )
                : SingleChildScrollView(
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 60.h),
                            Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(12)),
                                  child: profileCubit.profileImagePath == null
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
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: Image(
                                              fit: BoxFit.cover,
                                              image: ResizeImage(
                                                  height: 100.h.toInt(),
                                                  width: 100.h.toInt(),
                                                  FileImage(File(Constant
                                                      .currentUser!.imgUrl!)))),
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
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 24.w, vertical: 24.h),
                              padding: EdgeInsets.symmetric(vertical: 15.h),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      width: 1,
                                      color: const Color(0xFFC9C9C9))),
                              child: Column(children: [
                                buildListTile(
                                  context,
                                  "assets/images/proficon.png",
                                  "Personal Details",
                                  () async {
                                    await Navigator.of(context)
                                        .pushReplacement(MaterialPageRoute(
                                      builder: (context) => PersonalDetails(
                                          tabController: widget.tabController,
                                          pageController: widget.pageController,
                                          profileCubit: profileCubit),
                                    ));
                                  },
                                ),
                                buildListTile(
                                  context,
                                  "assets/images/Frame.png",
                                  "Shopping Address",
                                  () async {
                                    List<Map<String, dynamic>> addressList =
                                        await sl
                                            .get<DataSource>()
                                            .getLocations();
                                    if (context.mounted) {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
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
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (_) => ShoppingBagScreen(
                                                  addToCartCubit: context
                                                      .read<AddToCartCubit>(),
                                                )));
                                  },
                                ),
                                buildListTile(
                                  context,
                                  "assets/images/bag.png",
                                  "My Order",
                                  () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
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
                                    var res =
                                        await sl.get<DataSource>().getBorders();
                                    res.fold((borders) {
                                      if (context.mounted) {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) => WishListScreen(
                                            borders: borders,
                                          ),
                                        ));
                                      }
                                    }, (r) {
                                      if (context.mounted) {
                                        Toast.show(
                                            'Something went wrong please try again',
                                            duration: Toast.lengthLong);
                                      }
                                    });
                                  },
                                ),
                                buildListTile(
                                  context,
                                  "assets/images/star.png",
                                  "Rate this app",
                                  () {
                                    context.read<OrdersCubit>().changeRating(0);
                                    context
                                            .read<OrdersCubit>()
                                            .opinionController =
                                        TextEditingController();
                                    context.read<OrdersCubit>().character = 50;
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (_) => RatePage(
                                                  ordersCubit: context
                                                      .read<OrdersCubit>(),
                                                )));
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
                                  if (!profileCubit.isLogOutLoading) {
                                    profileCubit.setIsLogOutLoading(true);
                                    InternetInfo.isconnected()
                                        .then((value) async {
                                      XFile? image;
                                      if (value) {
                                        if (File(Constant.currentUser!.imgUrl!)
                                            .existsSync()) {
                                          image = XFile(
                                              Constant.currentUser!.imgUrl!);
                                        } else {
                                          image = null;
                                        }
                                        var isSuccess =
                                            await profileCubit.logOut(image);
                                        if (isSuccess) {
                                          if (context.mounted) {
                                            profileCubit
                                                .setIsLogOutLoading(false);
                                            Constant.currentUser = null;
                                            context
                                                .read<AddToCartCubit>()
                                                .fetchData();
                                          }
                                        } else {
                                          profileCubit
                                              .setIsLogOutLoading(false);
                                          if (context.mounted) {
                                            Toast.show(
                                                'Something went wrong please try again',
                                                duration: Toast.lengthLong);
                                          }
                                        }
                                      } else {
                                        profileCubit.setIsLogOutLoading(false);
                                        if (context.mounted) {
                                          Toast.show(
                                              'Check your internet connection',
                                              duration: Toast.lengthLong);
                                        }
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
                                  child:
                                      BlocBuilder<ProfileCubit, ProfileState>(
                                    builder: (context, state) {
                                      return profileCubit.isLogOutLoading
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
                  );
          },
        ));
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
