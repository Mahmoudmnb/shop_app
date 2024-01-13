import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop_app/core/constant.dart';
import 'package:shop_app/featurs/main_page/cubit/main_page_cubit.dart';
import 'package:shop_app/featurs/main_page/data_source/data_source.dart';
import 'package:shop_app/featurs/main_page/featurs/setting.dart';
import 'package:shop_app/injection.dart';

import '../../shopping_bag/screens/shopping_bag_screen.dart';
import '../../wishlist/screens/wishlist_screen.dart';
import '../cubit/drawer_cubit.dart';
import 'custom_button.dart';
import 'custom_list_tile.dart';
import 'profile.dart';

class HomeDrawer extends StatelessWidget {
  final TabController tabController;
  const HomeDrawer({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: Column(
        children: [
          SizedBox(height: 62.9.h),
          SingleChildScrollView(
            child: Column(
              children: [
                Profile(
                  image: Constant.currentUser!.imgUrl != null
                      ? FileImage(File(Constant.currentUser!.imgUrl!))
                      : null,
                  username: Constant.currentUser!.name,
                  email: Constant.currentUser!.email,
                ),
                SizedBox(height: 15.h),
                const Divider(color: Color(0xFFEAEAEA)),
                SizedBox(height: 15.h),
                BlocBuilder<DrawerCubit, DrawerState>(
                  builder: (context, state) {
                    log(state.toString());
                    int selectedItem = 0;
                    if (state is SelectedItem) {
                      selectedItem = state.selectedItem;
                    } else if (state is DrawerInitial) {
                      selectedItem = tabController.index;
                    }
                    return Column(
                      children: [
                        CustomListTile(
                          onTap: () {
                            tabController.animateTo(0);
                            context.read<MainPageCubit>().changePageIndex(0);
                            context.read<DrawerCubit>().changeSelectedItem(0);
                            Scaffold.of(context).closeDrawer();
                          },
                          icon: Icons.home_outlined,
                          title: 'Homepage',
                          isSelected: selectedItem == 0,
                        ),
                        SizedBox(height: 10.h),
                        CustomListTile(
                          onTap: () {
                            tabController.animateTo(1);
                            context.read<MainPageCubit>().changePageIndex(1);
                            context.read<DrawerCubit>().changeSelectedItem(1);
                            Scaffold.of(context).closeDrawer();
                          },
                          icon: Icons.search_rounded,
                          title: 'Discover',
                          isSelected: selectedItem == 1,
                        ),
                        SizedBox(height: 10.h),
                        CustomListTile(
                          onTap: () {
                            tabController.animateTo(2);
                            context.read<MainPageCubit>().changePageIndex(2);
                            context.read<DrawerCubit>().changeSelectedItem(2);
                            Scaffold.of(context).closeDrawer();
                          },
                          icon: Icons.shopping_bag_outlined,
                          title: 'My Order',
                          isSelected: selectedItem == 2,
                        ),
                        SizedBox(height: 10.h),
                        CustomListTile(
                          onTap: () {
                            tabController.animateTo(3);
                            context.read<MainPageCubit>().changePageIndex(3);
                            context.read<DrawerCubit>().changeSelectedItem(3);
                            Scaffold.of(context).closeDrawer();
                          },
                          icon: Icons.person_outline_rounded,
                          title: 'Profile',
                          isSelected: selectedItem == 3,
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(height: 10.h),
                const Divider(color: Color(0xFFEAEAEA)),
                SizedBox(height: 10.h),
                CustomListTile(
                  icon: Icons.shopping_cart_outlined,
                  title: 'Shopping Bag',
                  onTap: () {
                    Scaffold.of(context).closeDrawer();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => const ShoppingBagScreen()));
                  },
                ),
                SizedBox(height: 10.h),
                CustomListTile(
                  icon: Icons.favorite_outline_rounded,
                  title: 'Wishlist',
                  onTap: () async {
                    Scaffold.of(context).closeDrawer();
                    List<Map<String, dynamic>> borders =
                        await sl.get<DataSource>().getBorders();
                    if (context.mounted) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => WishListScreen(
                                borders: borders,
                              )));
                    }
                  },
                ),
                SizedBox(height: 10.h),
                const Divider(color: Color(0xFFEAEAEA)),
                SizedBox(height: 10.h),
                CustomListTile(
                  icon: Icons.settings_outlined,
                  title: 'Settings',
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const SettingPage()));
                  },
                ),
                SizedBox(height: 10.h),
                const CustomListTile(
                  icon: Icons.info_outline_rounded,
                  title: 'About Us',
                ),
                SizedBox(height: 10.h),
                const CustomListTile(
                  icon: Icons.email_outlined,
                  title: 'Support',
                ),
                SizedBox(height: 10.h),
                const CustomButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
