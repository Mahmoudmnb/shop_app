import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop_app/core/constant.dart';
import 'package:toast/toast.dart';

import '../../injection.dart';
import 'cubit/main_page_cubit.dart';
import 'data_source/data_source.dart';
import 'drawer/home_drawer.dart';
import 'featurs/home/pages/home_page.dart';
import 'featurs/home/widgets/main_page_tab_bar.dart';
import 'featurs/orders/screen/orders_screen.dart';
import 'featurs/profile/screen/profile_screen.dart';
import 'featurs/search/pages/search_screen.dart';
import 'featurs/shopping_bag/cubits/products_cubit/products_cubit.dart';
import 'featurs/shopping_bag/screens/shopping_bag_screen.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  @override
  void initState() {
    tabController = TabController(length: 4, vsync: this);

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
      leadingWidth: 95.w,
      leading: Row(
        children: [
          Builder(
            builder: (context) => IconButton(
                onPressed: () async {
                  Scaffold.of(context).openDrawer();
                },
                icon: Icon(
                  Icons.density_medium_rounded,
                  size: 25.sp,
                )),
          ),
          SizedBox(width: 2.w),
          IconButton(
              onPressed: () async {
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
                  ToastContext().init(context);
                  Toast.show('You have to register before you can go here',
                      duration: 2);
                }
              },
              icon: Icon(Icons.shopping_cart_outlined, size: 25.sp)),
        ],
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 4.0.w),
          child: IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () async {
              // try {
              //   final client = Client()
              //       .setEndpoint('https://cloud.appwrite.io/v1')
              //       .setProject(Constant.appWriteProjectId);
              //   Realtime realtime = Realtime(client);
              //   Databases databases = Databases(client);
              //   var data = realtime
              //       .subscribe([
              //         'databases.65585f55e896c3e87515.collections.655860259ae4b331bee6'
              //       ])
              //       .stream
              //       .listen((event) {
              //         log('error');
              //         log(event.payload.toString());
              //       });
              // } catch (e) {
              //   log(e.toString());
              // }

              //   try {
              //     File file1 = File(Constant.addToCartTable);
              //     Stream<String> lines = file1
              //         .openRead()
              //         .transform(utf8.decoder) // Decode bytes to UTF-8.
              //         .transform(const LineSplitter());
              //     await for (var line in lines) {
              //       print(line);
              //     }
              //     // File file = File(Constant.addToCartTable);
              //     // var res = await OpenFile.open(Constant.addToCartTable);
              //     // log(res.message);
              //     // log(file.existsSync().toString());
              //   } catch (e) {
              //     log(e.toString());
              //   }
            },
          ),
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
      backgroundColor: Colors.white,
      appBar: appBar,
      drawer: const Drawer(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
          ),
          child: HomeDrawer()),
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
        child: TabBarView(
          controller: tabController,
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
      ),
    );
  }
}
