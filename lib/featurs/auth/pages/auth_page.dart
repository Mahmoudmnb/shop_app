import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/featurs/main_page/data_source/data_source.dart';
import 'package:shop_app/featurs/main_page/main_page.dart';

import '../../../core/data_base.dart';
import '../../../injection.dart';
import '../blocs/auth_blocs.dart';
import '../widgets/auth_widgets.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    void goToHomePage() async {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      } else {
        sl.get<SharedPreferences>().setBool('isFirstTime', false);
        MyDataBase myDataBase = MyDataBase();
        myDataBase.createProductTable().then((value) {
          myDataBase.createReviewTable().then((value) {
            myDataBase.createSearchHistoryTable().then((value) {
              myDataBase.createAddToCartTable().then((value) {
                myDataBase.createLoactionsTable().then((value) {
                  myDataBase.createOrdersTable().then((value) {
                    sl
                        .get<DataSource>()
                        .getProductsFormCloudDataBase()
                        .then((value) {
                      sl.get<DataSource>().getOrdersFromCloud().then((value) {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const MainPage(),
                        ));
                      });
                    });
                  });
                });
              });
              // myDataBase.insertReviewTable().then((value) {
              //   myDataBase.insertData().then((value) {

              //   });
              // });
            });
          });
        });
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
              height: 816.h,
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
                          onPressed: () {
                            goToHomePage();
                          },
                        ),
                      ],
                    ),
                    Image.asset(
                      'assets/images/logo.png',
                      height: 170.h,
                      width: 170.h,
                    ),
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
                    AuthForm(goToHomePage: goToHomePage),
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
