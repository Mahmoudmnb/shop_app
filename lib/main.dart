import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/featurs/auth/pages/splash_screen.dart';
import 'package:sqflite/sqflite.dart';

import 'core/constant.dart';
import 'featurs/auth/blocs/email_text_bloc/email_text_bloc.dart';
import 'featurs/auth/blocs/sign_in_loading/sign_in_loading_bloc.dart';
import 'featurs/auth/blocs/sign_up_bloc/sign_up_bloc.dart';
import 'featurs/auth/blocs/visible_password_bloc/visible_password_bloc.dart';
import 'featurs/auth/models/user_model.dart';
import 'featurs/main_page/cubit/main_page_cubit.dart';
import 'featurs/main_page/featurs/check_out/cubit/check_out_cubit.dart';
import 'featurs/main_page/featurs/home/blocs/discount/discount_products_bloc.dart';
import 'featurs/main_page/featurs/orders/cubit/orders_cubit.dart';
import 'featurs/main_page/featurs/products_view/cubits/product_screen/cubit.dart';
import 'featurs/main_page/featurs/profile/cubit/profile_cubit.dart';
import 'featurs/main_page/featurs/search/cubit/sreach_cubit.dart';
import 'featurs/main_page/featurs/shopping_bag/cubits/item_product_cubit/item_product_cubit.dart';
import 'featurs/main_page/featurs/shopping_bag/cubits/products_cubit/products_cubit.dart';
import 'featurs/main_page/main_page.dart';
import 'injection.dart';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // await Supabase.initialize(
  //   url: Constant.supabaseUrl,
  //   anonKey: Constant.supabaseAnonkey,
  // );
  init();
  SharedPreferences db = await SharedPreferences.getInstance();
  String? user = db.getString('currentUser');
  if (user != null) {
    Constant.currentUser = UserModel.fromJson(user);
  }
  String? baseUrl = db.getString('baseUrl');
  if (baseUrl == null) {
    baseUrl = await getDatabasesPath();
    db.setString('baseUrl', baseUrl);
    Constant.baseUrl = baseUrl;
  }
  runApp(MultiBlocProvider(providers: [
    BlocProvider(
      create: (context) => VisiblePsswordBloc(),
    ),
    BlocProvider(
      create: (context) => EmailTextBloc(),
    ),
    BlocProvider(
      create: (context) => SignUpBloc(),
    ),
    BlocProvider(
      create: (context) => SignInLoadingBloc(),
    ),
    BlocProvider(
      create: (context) => DiscountProductsBloc(),
    ),
    BlocProvider(
      create: (context) => SearchCubit(),
    ),
    BlocProvider(
      create: (context) => ProductCubit(),
    ),
    BlocProvider(
      create: (context) => MainPageCubit(),
    ),
    BlocProvider(
      create: (context) => OrdersCubit(),
    ),
    BlocProvider(
      create: (context) => ProfileCubit(),
    ),
    BlocProvider(
      create: (context) => AddToCartCubit(),
    ),
    BlocProvider(
      create: (context) => ItemProductCubit(),
    ),
    BlocProvider(
      create: (context) => CheckOutCubit(),
    ),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(393, 852),
        builder: (context, child) => MaterialApp(
              debugShowCheckedModeBanner: false,
              home: sl.get<SharedPreferences>().getBool('isFirstTime') == null
                  ? SplashScreen(deviceHeight: 852.h, deviceWidth: 393.w)
                  : const MainPage(),
            ));
  }
}
