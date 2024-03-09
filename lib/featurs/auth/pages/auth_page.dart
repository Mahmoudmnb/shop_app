import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/core/internet_info.dart';
import 'package:toast/toast.dart';

import '../../../core/data_base.dart';
import '../../../injection.dart';
import '../../main_page/data_source/data_source.dart';
import '../../main_page/featurs/profile/cubit/profile_cubit.dart';
import '../../main_page/featurs/shopping_bag/cubits/products_cubit/products_cubit.dart';
import '../../main_page/main_page.dart';
import '../blocs/auth_blocs.dart';
import '../widgets/auth_widgets.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<VisiblePsswordBloc>().add(ShowPassword());
    Future<void> goToHomePage(String fromButton) async {
      if (Navigator.of(context).canPop()) {
        if (fromButton != 'Skip') {
          await sl.get<DataSource>().getOrdersFromCloud();
          await sl.get<DataSource>().insertPersonalData();
          if (context.mounted) {
            await context.read<AddToCartCubit>().getAddToCartProducts();
            if (context.mounted) {
              context.read<AddToCartCubit>().fetchData();
              context.read<ProfileCubit>().updateProfileImageWidget();
            }
          }
        }
        if (context.mounted) {
          Navigator.of(context).pop();
        }
      } else {
        MyDataBase myDataBase = MyDataBase();
        await sl.get<SharedPreferences>().setBool('isFirstTime', false);
        await myDataBase.createProductTable();
        await myDataBase.createReviewTable();
        await myDataBase.createSearchHistoryTable();
        await myDataBase.createAddToCartTable();
        await myDataBase.createLoactionsTable();
        await myDataBase.createOrdersTable();
        await myDataBase.createBorderTable();
        await myDataBase.createBorderProductsTable();
        await myDataBase.createRecommendedProductTable();

        await sl.get<DataSource>().addBorder('All items');
        await sl.get<DataSource>().getProductsFormCloudDataBase();
        await sl.get<DataSource>().setRecommendedProducts();
        await sl.get<DataSource>().getReviewsFromCloud();
        if (fromButton != 'Skip') {
          await sl.get<DataSource>().getOrdersFromCloud();
          await sl.get<DataSource>().insertPersonalData();
        }
        if (context.mounted) {
          await context.read<AddToCartCubit>().getAddToCartProducts();
          sl.get<SharedPreferences>().setString(
              'lastUpdate', DateTime.now().millisecondsSinceEpoch.toString());
          if (context.mounted) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const MainPage(),
            ));
          }
        }
      }
    }

    return SafeArea(
      child: ScreenUtilInit(
        designSize: const Size(393, 852),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, _) => Scaffold(
          body: SingleChildScrollView(
            child: SizedBox(
              height: 800.h,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 17.5.w),
                child: Column(
                  children: [
                    SizedBox(height: 8.5.h),
                    Row(
                      children: [
                        const Spacer(),
                        TextButton(
                          style: TextButton.styleFrom(
                              foregroundColor: const Color(0xFF2E2E2E)),
                          child: Text('Skip',
                              style: TextStyle(
                                  fontFamily: 'DM Sans', fontSize: 22.sp)),
                          onPressed: () async {
                            bool isConnected = await InternetInfo.isconnected();
                            if (isConnected) {
                              goToHomePage('Skip');
                            } else {
                              if (context.mounted) {
                                ToastContext().init(context);
                                Toast.show('Check you internet connection',
                                    duration: Toast.lengthLong);
                              }
                            }
                          },
                        ),
                      ],
                    ),
                    Image.asset('assets/images/logo.png',
                        height: 170.h, width: 170.h),
                    SizedBox(height: 8.5.h),
                    Row(
                      children: [
                        SizedBox(width: 8.5.h),
                        BlocBuilder<SignUpBloc, SignUpBlocState>(
                          builder: (context, state) {
                            bool isSignUp = false;
                            if (state is SignUpBlocInitial) {
                              isSignUp = true;
                            } else if (state is IsSignUp) {
                              isSignUp = state.isSignUp;
                            }
                            return SwitchBetweenTwoTextWithRotation(
                                isFirestText: isSignUp,
                                firstText: 'Sign In',
                                secondText: 'Sign Up',
                                textStyle: TextStyle(
                                    fontFamily: 'DM Sans', fontSize: 24.sp));
                          },
                        ),
                      ],
                    ),
                    AuthForm(goToHomePage: () async {
                      await goToHomePage('Register');
                    }),
                    SizedBox(height: 8.5.h),
                    const AlternativeSignIn(),
                    const Expanded(child: SizedBox.shrink()),
                    SizedBox(
                      child: BlocBuilder<SignUpBloc, SignUpBlocState>(
                        builder: (context, state) {
                          bool isSignUp = false;
                          if (state is SignUpBlocInitial) {
                            isSignUp = true;
                          } else if (state is IsSignUp) {
                            isSignUp = state.isSignUp;
                          }
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SwitchBetweenTwoText(
                                  isFirestText: isSignUp,
                                  firstText: '     Don\'t have an account?',
                                  secondText: 'Already have an account?',
                                  textStyle:
                                      const TextStyle(fontFamily: 'DM Sans')),
                              SizedBox(width: 4.w),
                              TextButton(
                                style: TextButton.styleFrom(
                                    foregroundColor: const Color(0xFF646464)),
                                child: SwitchBetweenTwoTextWithRotation(
                                    firstText: 'Sign Up',
                                    isFirestText: isSignUp,
                                    secondText: 'Sign IN',
                                    textStyle: const TextStyle(
                                        fontFamily: 'DM Sans',
                                        decoration: TextDecoration.underline,
                                        fontSize: 14)),
                                onPressed: () {
                                  if (state is SignUpBlocInitial) {
                                    context.read<SignUpBloc>().add(
                                        ChangeBetweenSignUpOrSignIn(
                                            isSignUp: false));
                                  } else if (state is IsSignUp) {
                                    context.read<SignUpBloc>().add(
                                        ChangeBetweenSignUpOrSignIn(
                                            isSignUp: !state.isSignUp));
                                  }
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 30.h)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
