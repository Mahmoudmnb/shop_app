import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop_app/core/constant.dart';

import '../../injection.dart';
import 'cubit/main_page_cubit.dart';
import 'data_source/data_source.dart';
import 'featurs/drawer/cubit/drawer_cubit.dart';
import 'featurs/drawer/widgets/drawer.dart';
import 'featurs/home/pages/home_page.dart';
import 'featurs/home/widgets/main_page_tab_bar.dart';
import 'featurs/orders/screen/orders_screen.dart';
import 'featurs/profile/screen/profile_screen.dart';
import 'featurs/search/screen/search_screen.dart';
import 'featurs/shopping_bag/cubits/products_cubit/products_cubit.dart';
import 'featurs/shopping_bag/screens/shopping_bag_screen.dart';
import 'featurs/wishlist/screens/wishlist_screen.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  late PageController pageController;
  testRealTime() {
    try {
      final client = Client()
          .setEndpoint('https://cloud.appwrite.io/v1')
          .setProject(Constant.appWriteProjectId);

      final realtime = Realtime(client);

// Subscribe to files channel  'databases.A.collections.A.documents.A'

      final subscription = realtime.subscribe([
        'databases.655da767bc3f1651db70.collections.655da771422b6ac710aa.documents'
      ]);
      subscription.stream.listen((event) {
        log(event.payload.toString());
      });
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  void initState() {
    sl.get<DataSource>().getAddToCartProducts().then((value) {
      context.read<AddToCartCubit>().products = value;
      setState(() {});
    });
    tabController = TabController(length: 4, vsync: this);
    pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // debugInvertOversizedImages = true;
    final AppBar appBar = AppBar(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
      leadingWidth: 100.w,
      // toolbarHeight: 80,
      leading: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Builder(
            builder: (context) => IconButton(
                onPressed: () async {
                  context
                      .read<DrawerCubit>()
                      .changeSelectedItem(tabController.index);
                  Scaffold.of(context).openDrawer();
                },
                icon: Icon(
                  Icons.density_medium_rounded,
                  size: 25.sp,
                )),
          ),
          IconButton(onPressed: () async {
            if (Constant.currentUser != null) {
              await sl
                  .get<DataSource>()
                  .getAddToCartProducts()
                  .then((addToCartProducts) {
                context.read<AddToCartCubit>().products = addToCartProducts;
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const ShoppingBagScreen(),
                ));
              });
            } else {
              context.read<MainPageCubit>().showRegisterMessage(context);
            }
          }, icon: BlocBuilder<AddToCartCubit, AddToCartState>(
            builder: (context, state) {
              if (context.read<AddToCartCubit>().products.isNotEmpty &&
                  Constant.currentUser != null) {
                return SizedBox(
                  width: 37.w,
                  height: 35.h,
                  child: Stack(
                    fit: StackFit.expand,
                    alignment: Alignment.center,
                    children: [
                      Icon(Icons.shopping_cart_outlined, size: 25.sp),
                      Positioned(
                        right: 0.w,
                        bottom: -5.h,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black,
                          ),
                          child: Text(
                            context
                                .read<AddToCartCubit>()
                                .products
                                .length
                                .toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }
              return Icon(Icons.shopping_cart_outlined, size: 25.sp);
            },
          )),
        ],
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 4.w),
          child: IconButton(
              icon: const Icon(Icons.favorite_border),
              onPressed: () async {
                List<Map<String, dynamic>> borders =
                    await sl.get<DataSource>().getBorders();
                if (context.mounted) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => WishListScreen(
                            borders: borders,
                          )));
                }
              }),
        )
      ],
      centerTitle: true,
      title: BlocBuilder<MainPageCubit, MainPageState>(
        builder: (context, state) {
          int pageIndex = context.read<MainPageCubit>().pageIndex;
          return Text(
              pageIndex == 0
                  ? 'Home'
                  : pageIndex == 1
                      ? 'Discover'
                      : pageIndex == 2
                          ? 'My Orders'
                          : 'Profile',
              style: TextStyle(fontFamily: 'DM Sans', fontSize: 30.sp));
        },
      ),
    );

    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: appBar,
      drawer: SafeArea(
        child: Drawer(
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
            child: HomeDrawer(tabController: tabController)),
      ),
      body: WillPopScope(
        onWillPop: () async {
          if (tabController.index == 0) {
            bool key = false;
            key = await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Do you realy want to exit'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: const Text('Yes')),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: const Text('NO'))
                ],
              ),
            );
            return key;
          } else {
            tabController.animateTo(0);
            return false;
          }
        },
        child: PageView(
          controller: pageController,
          onPageChanged: (index) {
            context.read<MainPageCubit>().changePageIndex(index);

            tabController.animateTo(index);
          },
          children: [
            FutureBuilder(
              future: sl.get<DataSource>().getDiscountsProducts(),
              builder: (context, snapshot) => snapshot.hasData
                  ? FutureBuilder(
                      future: sl.get<DataSource>().getTrendyProducts(),
                      builder: (context, snapshot1) => snapshot1.hasData
                          ? HomePage(
                              disCountProducts: snapshot.data!,
                              trindyProducts: snapshot1.data!,
                            )
                          : const Center(
                              child: CircularProgressIndicator(),
                            ))
                  : const SizedBox.shrink(),
            ),
            const SearchScreen(),
            const MyOrdersScreen(),
            const ProfileScreen(),
          ],
        ),
      ),
      bottomNavigationBar: MainPageTabBar(
        tabController: tabController,
        pageController: pageController,
      ),
    );
  }
}
