import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop_app/featurs/main_page/featurs/wishlist/screens/wishlist_screen.dart';

import 'widgets/custom_button.dart';
import 'widgets/custom_list_tile.dart';
import 'widgets/profile.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

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
                const Profile(
                  image: null,
                  username: 'Mohammed Jalab',
                  email: 'jalabmouhamed@gmail.com',
                ),
                SizedBox(height: 15.h),
                const Divider(color: Color(0xFFEAEAEA)),
                SizedBox(height: 15.h),
                const CustomListTile(
                  icon: Icons.home_outlined,
                  title: 'Homepage',
                  isSelected: true,
                ),
                SizedBox(height: 10.h),
                const CustomListTile(
                  icon: Icons.search_rounded,
                  title: 'Discover',
                ),
                SizedBox(height: 10.h),
                const CustomListTile(
                  icon: Icons.shopping_bag_outlined,
                  title: 'My Order',
                ),
                SizedBox(height: 10.h),
                const CustomListTile(
                  icon: Icons.person_outline_rounded,
                  title: 'Profile',
                ),
                SizedBox(height: 10.h),
                const Divider(color: Color(0xFFEAEAEA)),
                SizedBox(height: 10.h),
                const CustomListTile(
                  icon: Icons.shopping_cart_outlined,
                  title: 'Shopping Bag',
                ),
                SizedBox(height: 10.h),
                CustomListTile(
                  icon: Icons.favorite_outline_rounded,
                  title: 'Wishlist',
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const WishListScreen(
                              borders: [],
                            )));
                  },
                ),
                SizedBox(height: 10.h),
                const Divider(color: Color(0xFFEAEAEA)),
                SizedBox(height: 10.h),
                const CustomListTile(
                  icon: Icons.settings_outlined,
                  title: 'Settings',
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
