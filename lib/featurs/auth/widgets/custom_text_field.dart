import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../blocs/auth_blocs.dart';
import '../data.dart';
import 'auth_widgets.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  const CustomTextField(
      {super.key, required this.hintText, required this.controller});
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VisiblePsswordBloc, VisiblePasswordState>(
      builder: (context, visiblePasswordState) {
        return BlocBuilder<EmailTextBloc, EmailTextState>(
          builder: (context1, emailTextState) {
            return BlocBuilder<SignUpBloc, SignUpBlocState>(
              builder: (context2, signUpState) {
                bool isSignUP = false;
                if (signUpState is SignUpBlocInitial) {
                  isSignUP = true;
                } else if (signUpState is IsSignUp) {
                  isSignUP = signUpState.isSignUp;
                }
                return HideItem(
                    maxHight: 60,
                    visabl: (!isSignUP &&
                            (hintText == 'Enter your name' ||
                                hintText == 'Confirm Password'))
                        ? false
                        : true,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        onTapOutside: (event) {
                          FocusScope.of(context).unfocus();
                        },
                        obscureText:
                            (visiblePasswordState is VisiblePasswordInitial &&
                                    (hintText == 'Password' ||
                                        hintText == 'Confirm Password'))
                                ? true
                                : visiblePasswordState is VisiblePassword
                                    ? (visiblePasswordState.isVisible &&
                                            (hintText == 'Password' ||
                                                hintText == 'Confirm Password'))
                                        ? true
                                        : false
                                    : false,
                        keyboardType: hintText == 'Email address'
                            ? TextInputType.emailAddress
                            : hintText == 'Password' ||
                                    hintText == 'Confirm Password'
                                ? TextInputType.visiblePassword
                                : TextInputType.name,
                        validator: (value) {
                          bool isSignUp = false;
                          if (signUpState is SignUpBlocInitial) {
                            isSignUp = true;
                          } else if (signUpState is IsSignUp) {
                            isSignUp = signUpState.isSignUp;
                          }
                          return validator(value, isSignUp);
                        },
                        onSaved: (newValue) {
                          onSave(newValue);
                        },
                        onChanged: (value) {
                          if (hintText == 'Password') {
                            Data.tempPassword = value.trim();
                          } else if (hintText == 'Email address') {
                            context
                                .read<EmailTextBloc>()
                                .add(ChangeEmailText(emailText: value));
                          }
                        },
                        decoration: InputDecoration(
                          suffixIcon: hintText == 'Email address'
                              ? Icon(
                                  Icons.check_circle_outline,
                                  color: emailTextState is EmailText
                                      ? (emailTextState.emailText.isEmpty
                                          ? Colors.grey
                                          : (!emailTextState.emailText
                                                      .contains('@') ||
                                                  !emailTextState.emailText
                                                      .endsWith('.com'))
                                              ? Colors.red
                                              : Colors.green)
                                      : Colors.grey,
                                )
                              : hintText == 'Password'
                                  ? IconButton(
                                      onPressed: () {
                                        if (visiblePasswordState
                                            is VisiblePasswordInitial) {
                                          context
                                              .read<VisiblePsswordBloc>()
                                              .add(HidePassword());
                                        } else if (visiblePasswordState
                                            is VisiblePassword) {
                                          if (visiblePasswordState.isVisible) {
                                            context
                                                .read<VisiblePsswordBloc>()
                                                .add(HidePassword());
                                          } else {
                                            context
                                                .read<VisiblePsswordBloc>()
                                                .add(ShowPassword());
                                          }
                                        }
                                      },
                                      icon: visiblePasswordState
                                              is VisiblePasswordInitial
                                          ? const Icon(
                                              Icons.visibility_outlined,
                                              color: Colors.grey)
                                          : visiblePasswordState
                                                  is VisiblePassword
                                              ? Icon(
                                                  visiblePasswordState.isVisible
                                                      ? Icons
                                                          .visibility_outlined
                                                      : Icons
                                                          .visibility_off_outlined,
                                                  color: Colors.grey)
                                              : const SizedBox.shrink(),
                                    )
                                  : null,
                          hintStyle: GoogleFonts.dmSans(fontSize: 14.sp),
                          hintText: hintText,
                          border: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFFD6D6D6),
                            ),
                          ),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFFD6D6D6),
                            ),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFFD6D6D6),
                            ),
                          ),
                        ),
                      ),
                    ));
              },
            );
          },
        );
      },
    );
  }

  void onSave(String? newValue) {
    if (hintText == 'Enter your name') {
      Data.name = newValue!.trim();
    } else if (hintText == 'Email address') {
      Data.email = newValue!.trim();
    } else if (hintText == 'Password') {
      Data.password = newValue!.trim();
    } else {
      Data.confirmPassword = newValue!.trim();
    }
  }

  String? validator(String? newValue, bool isSignUp) {
    String? value;
    if (newValue != null) {
      value = newValue.trim();
    }
    if (hintText == 'Enter your name' && isSignUp) {
      if (value == null || value.isEmpty || value.length <= 6) {
        return 'Name shold be more than six chrachters';
      }
    } else if (hintText == 'Email address') {
      if (value == null || !value.contains('@') || !value.endsWith('.com')) {
        return 'Invalid email';
      }
    } else if (hintText == 'Password') {
      if (value == null || value.isEmpty || value.length <= 6) {
        return 'password shold be more than six chrachters';
      }
    } else if (hintText == 'Confirm Password' && isSignUp) {
      if (value == null ||
          value.compareTo(Data.tempPassword.trim()) != 0 ||
          value.isEmpty) {
        return "Confirm password is empty or it doesn't match password field ";
      }
    }
    return null;
  }
}
