import 'dart:async';

import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import '../../../core/data_base.dart';
import '../../../core/internet_info.dart';
import '../../../injection.dart';
import '../../main_page/data_source/data_source.dart';
import '../../main_page/featurs/profile/cubit/profile_cubit.dart';
import '../../main_page/featurs/shopping_bag/cubits/products_cubit/products_cubit.dart';
import '../../main_page/main_page.dart';
import '../blocs/auth_blocs.dart';
import '../widgets/auth_widgets.dart';

class AuthPage extends StatelessWidget {
  final String fromPage;
  const AuthPage({super.key, required this.fromPage});

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    context.read<VisiblePsswordBloc>().add(ShowPassword());
    Future<bool> goToHomePage(String fromButton) async {
      if (fromPage == 'Profile') {
        if (fromButton != 'Skip') {
          List<Document> locations = [];
          var result = await sl.get<DataSource>().downloadLoactionsFromCloud();
          bool s = result.fold((newLocations) {
            locations = newLocations;
            return true;
          }, (r) {
            return false;
          });
          if (!s) {
            return false;
          }
          if (!await sl.get<DataSource>().getOrdersFromCloud()) {
            return false;
          }

          if (!await sl.get<DataSource>().insertPersonalData()) {
            return false;
          }
          if (sl.get<SharedPreferences>().getString('defaultLocation') ==
                  null &&
              locations.isNotEmpty) {
            await sl
                .get<SharedPreferences>()
                .setString('defaultLocation', locations[0].data['addressName']);
          }
          var res = await sl.get<DataSource>().updateDataBase();
          if (!res.fold((l) => true, (r) => false)) {
            return false;
          }
          await sl.get<SharedPreferences>().setString(
              'lastUpdate', DateTime.now().millisecondsSinceEpoch.toString());
          if (context.mounted) {
            if (!await context.read<AddToCartCubit>().getAddToCartProducts()) {
              return false;
            }
            if (context.mounted) {
              context.read<AddToCartCubit>().fetchData();
              context.read<ProfileCubit>().updateProfileImageWidget();
            }
          }
        }
        if (context.mounted) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const MainPage(),
          ));
        }
        return true;
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
        if (!await sl.get<DataSource>().getProductsFormCloudDataBase()) {
          return false;
        }
        if (!await sl.get<DataSource>().setRecommendedProducts()) {
          return false;
        }
        if (!await sl.get<DataSource>().getReviewsFromCloud()) {
          return false;
        }
        List<Document> locations = [];
        if (fromButton != 'Skip') {
          if (!await sl.get<DataSource>().getOrdersFromCloud()) {
            return false;
          }
          if (!await sl.get<DataSource>().insertPersonalData()) {
            return false;
          }
          // locations = await sl.get<DataSource>().downloadLoactionsFromCloud();
        }
        if (context.mounted) {
          if (sl.get<SharedPreferences>().getString('defaultLocation') ==
                  null &&
              locations.isNotEmpty) {
            await sl
                .get<SharedPreferences>()
                .setString('defaultLocation', locations[0].data['addressName']);
          }
          if (!await context.read<AddToCartCubit>().getAddToCartProducts()) {
            return false;
          }
          await sl.get<SharedPreferences>().setString(
              'lastUpdate', DateTime.now().millisecondsSinceEpoch.toString());
          if (context.mounted) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const MainPage(),
            ));
          }
        }
        return true;
      }
    }

    void skipButtonOnTab() async {
      context
          .read<SignInLoadingBloc>()
          .add(ChangeSkipButtonLoading(isLoading: true));
      bool isConnected = await InternetInfo.isconnected();
      if (isConnected) {
        if (!await goToHomePage('Skip')) {
          Toast.show('Something went wrong please try again');
        }
        context
            .read<SignInLoadingBloc>()
            .add(ChangeSkipButtonLoading(isLoading: false));
      } else {
        if (context.mounted) {
          Toast.show('Check you internet connection',
              duration: Toast.lengthLong);
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
                    BlocBuilder<SignInLoadingBloc, SignInLoadingState>(
                      builder: (context, state) {
                        bool isLoading = false;
                        if (state is IsSkipButtonLoading) {
                          isLoading = state.isLoading;
                        }
                        return Row(
                          children: [
                            const Spacer(),
                            TextButton(
                                style: TextButton.styleFrom(
                                    foregroundColor: const Color(0xFF2E2E2E)),
                                child: isLoading
                                    ? CircularProgressIndicator(
                                        color: Colors.black)
                                    : Text('Skip',
                                        style: TextStyle(
                                            fontFamily: 'DM Sans',
                                            fontSize: 22.sp)),
                                onPressed: state is IsLoading
                                    ? state.isLoading
                                        ? null
                                        : state is IsSkipButtonLoading
                                            ? state.isLoading
                                                ? null
                                                : skipButtonOnTab
                                            : skipButtonOnTab
                                    : state is IsSkipButtonLoading
                                        ? state.isLoading
                                            ? null
                                            : skipButtonOnTab
                                        : skipButtonOnTab)
                          ],
                        );
                      },
                    ),
                    Image.asset('assets/images/logo.png',
                        height: 170.h, width: 170.h),
                    //! this image was so bad
                    // Image(
                    //     image: ResizeImage(
                    //         height: 125.h.toInt(),
                    //         width: 170.w.toInt(),
                    //         const AssetImage('assets/images/logo.png'))),
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
                      bool isSuccess = await goToHomePage('Register');
                      if (!isSuccess) {
                        Toast.show('Something went wrong please try again');
                      }
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
