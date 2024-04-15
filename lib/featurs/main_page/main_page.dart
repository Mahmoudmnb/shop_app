import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/core/constant.dart';
import 'package:toast/toast.dart';

import '../../injection.dart';
import 'cubit/main_page_cubit.dart';
import 'data_source/data_source.dart';
import 'featurs/drawer/cubit/drawer_cubit.dart';
import 'featurs/drawer/widgets/drawer.dart';
import 'featurs/home/pages/home_page.dart';
import 'featurs/home/widgets/main_page_tab_bar.dart';
import 'featurs/orders/screen/orders_screen.dart';
import 'featurs/profile/cubit/profile_cubit.dart';
import 'featurs/profile/screen/profile_screen.dart';
import 'featurs/search/screen/search_screen.dart';
import 'featurs/shopping_bag/cubits/products_cubit/products_cubit.dart';
import 'featurs/shopping_bag/screens/shopping_bag_screen.dart';

class MainPage extends StatefulWidget {
  final PageController? pageController;
  final TabController? tabController;

  const MainPage({super.key, this.pageController, this.tabController});

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
      value.fold((l) {
        context.read<AddToCartCubit>().products = l;
      }, (r) {});
      setState(() {});
    });
    tabController =
        widget.tabController ?? TabController(length: 4, vsync: this);
    pageController = widget.pageController ?? PageController();
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    // debugInvertOversizedImages = true;
    final AppBar appBar = AppBar(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
      leadingWidth: 100.w,
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
              var cartProducts =
                  await sl.get<DataSource>().getAddToCartProducts();
              cartProducts.fold((l) {
                context.read<AddToCartCubit>().products = l;
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ShoppingBagScreen(
                    addToCartCubit: context.read<AddToCartCubit>(),
                  ),
                ));
              }, (r) {
                Toast.show('Something went wrong please try again',
                    duration: Toast.lengthLong);
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
                // log(DateTime.now().millisecondsSinceEpoch.toString());
                try {
                  await http.get(
                      Uri.parse('http://localhost/project/rest_api.php'),
                      headers: {'Content-Type': 'application/json'});
                } catch (e) {
                  log(e.toString());
                }

                // var res = await sl.get<DataSource>().getBorders();
                // res.fold((borders) {
                //   if (context.mounted) {
                //     Navigator.of(context).push(MaterialPageRoute(
                //         builder: (context) => WishListScreen(
                //               borders: borders,
                //             )));
                //   }
                // }, (r) {
                //   Toast.show('Something went wrong please try again',
                //       duration: Toast.lengthLong);
                // });
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
            child: HomeDrawer(
              tabController: tabController,
              pageController: pageController,
              drawerCubit: context.read<DrawerCubit>(),
              profileCubit: context.read<ProfileCubit>(),
            )),
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
            pageController.animateToPage(0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.linear);
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
                future: sl.get<DataSource>().getTrendyProducts(),
                builder: (context, snapshot1) {
                  return snapshot1.hasData
                      ? HomePage(
                          trindyProducts: snapshot1.data!,
                        )
                      : const Center(
                          child: CircularProgressIndicator(),
                        );
                }),
            const SearchScreen(),
            const MyOrdersScreen(),
            ProfileScreen(
              pageController: pageController,
              tabController: tabController,
              profileCubit: context.read<ProfileCubit>(),
            ),
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
