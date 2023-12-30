import 'dart:developer';
import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/core/constant.dart';
import 'package:shop_app/core/internet_info.dart';
import 'package:shop_app/featurs/auth/models/user_model.dart';
import 'package:shop_app/injection.dart';
import 'package:toast/toast.dart';
import 'package:uuid/uuid.dart';

import '../blocs/auth_blocs.dart';
import '../data.dart';
import 'auth_widgets.dart';

class AuthForm extends StatefulWidget {
  final void Function() goToHomePage;
  const AuthForm({super.key, required this.goToHomePage});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  late TextEditingController nameCon;
  late TextEditingController emailCon;
  late TextEditingController passwordCon;
  late TextEditingController confirmPasswordcon;
  late GlobalKey<FormState> formKey;
  @override
  void initState() {
    nameCon = TextEditingController();
    emailCon = TextEditingController();
    passwordCon = TextEditingController();
    confirmPasswordcon = TextEditingController();
    formKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  void dispose() {
    nameCon.dispose();
    emailCon.dispose();
    passwordCon.dispose();
    confirmPasswordcon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Column(
      children: [
        Form(
            key: formKey,
            child: Column(
              children: [
                SizedBox(height: 8.5.h),
                CustomTextField(
                  hintText: 'Enter your name',
                  controller: nameCon,
                ),
                SizedBox(height: 8.5.h),
                CustomTextField(
                  hintText: 'Email address',
                  controller: emailCon,
                ),
                SizedBox(height: 8.5.h),
                CustomTextField(
                  hintText: 'Password',
                  controller: passwordCon,
                ),
                SizedBox(height: 8.5.h),
                CustomTextField(
                  hintText: 'Confirm Password',
                  controller: confirmPasswordcon,
                ),
                SizedBox(height: 25.5.h),
              ],
            )),
        BlocBuilder<SignUpBloc, SignUpBlocState>(
          builder: (context, state) {
            bool isSignUP = false;
            if (state is SignUpBlocInitial) {
              isSignUP = true;
            } else if (state is IsSignUp) {
              isSignUP = state.isSignUp;
            }
            return AuthCustomButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  String name = Data.name;
                  String email = Data.email;
                  String password = Data.password;
                  if (await InternetInfo.isconnected()) {
                    if (isSignUP) {
                      signUp(email.trim(), password.trim(), name.trim());
                    } else {
                      signIn(email.trim(), password.trim());
                    }
                  } else {
                    Toast.show('Check you internet connection', duration: 2);
                  }
                }
              },
              text: BlocBuilder<SignInLoadingBloc, SignInLoadingState>(
                builder: (context1, state1) {
                  bool isLoading = false;
                  if (state1 is IsLoading) {
                    if (state1.isLoading) {
                      isLoading = true;
                    }
                  }
                  return isLoading
                      ? const CircularProgressIndicator()
                      : SwitchBetweenTwoTextWithRotation(
                          isFirestText: isSignUP,
                          firstText: 'LOG IN',
                          secondText: 'SIGN UP',
                          textStyle: GoogleFonts.dmSans(fontSize: 16.sp));
                },
              ),
            );
          },
        ),
        SizedBox(height: 8.5.h),
      ],
    );
  }

  signIn(String email, String password) async {
    changeButtonLoadingState(true);
    Client client = Client();
    client = Client()
        .setEndpoint("https://cloud.appwrite.io/v1")
        .setProject(Constant.appWriteProjectId);
    Account account = Account(client);
    Databases database = Databases(client);
    try {
      await account.createEmailSession(email: email, password: password);
      var data = await database.listDocuments(
          databaseId: '655da767bc3f1651db70',
          collectionId: '655da771422b6ac710aa',
          queries: [Query.equal('email', email)]);
      String name = data.documents[0].data['name'];
      Constant.currentUser =
          UserModel(email: email, name: name, password: password);
      sl
          .get<SharedPreferences>()
          .setString('currentUser', Constant.currentUser!.toJson());
      widget.goToHomePage();
      changeButtonLoadingState(false);
      log('done');
    } on AppwriteException catch (e) {
      log(e.toString());
      if (e.message != null &&
          e.message!.contains('user_invalid_credentials')) {
        Toast.show('wrong email or password', duration: 2);
      } else {
        Toast.show('unkown error please try again');
      }
      changeButtonLoadingState(false);
    } on SocketException {
      changeButtonLoadingState(false);
      Toast.show('Your internet is week please check your internet connection');
    } catch (e) {
      log(e.toString());
    }

    // changeButtonLoadingState(true);
    // SupabaseClient supabase = Supabase.instance.client;
    // try {
    //   await supabase.auth.signInWithPassword(password: password, email: email);
    //   var data = await supabase.from('users').select('name').eq('email', email);
    //   String userName = data[0]['name'];
    //   Constant.currentUser =
    //       UserModel(email: email, name: userName, password: password);
    //   sl
    //       .get<SharedPreferences>()
    //       .setString('currentUser', Constant.currentUser!.toJson());
    //   changeButtonLoadingState(false);
    //   widget.goToHomePage();
    // } on AuthException {
    //   changeButtonLoadingState(false);
    //   Toast.show('Invalid email or password', duration: 2);
    // } on SocketException {
    //   changeButtonLoadingState(false);
    //   Toast.show('Check your internet connection');
    // }
  }

  signUp(String email, String password, String name) async {
    changeButtonLoadingState(true);
    String id = const Uuid().v1();
    Client client = Client();
    client = Client()
        .setEndpoint("https://cloud.appwrite.io/v1")
        .setProject(Constant.appWriteProjectId);
    Account account = Account(client);
    Databases database = Databases(client);
    try {
      await account.create(userId: id, email: email, password: password);
      Constant.currentUser =
          UserModel(email: email, name: name, password: password);
      sl
          .get<SharedPreferences>()
          .setString('currentUser', Constant.currentUser!.toJson());
      await database.createDocument(
          databaseId: '655da767bc3f1651db70',
          collectionId: '655da771422b6ac710aa',
          documentId: id,
          data: {'email': email, 'name': name, 'password': password});
      widget.goToHomePage();
      changeButtonLoadingState(false);
      log('done');
    } on AppwriteException catch (e) {
      log(e.toString());
      if (e.message != null && e.message!.contains('user_already_exists')) {
        Toast.show('user already exists for this email');
      } else {
        Toast.show('unkown error please try again');
      }
      changeButtonLoadingState(false);
    } on SocketException {
      changeButtonLoadingState(false);
      Toast.show('Your internet is week please check your internet connection');
    } catch (e) {
      log(e.toString());
    }
    //! this is for supabase signUp
    // try {
    // SupabaseClient supabase = Supabase.instance.client;
    // await supabase.auth.signUp(password: password, email: email);
    // await supabase
    //     .from('users')
    //     .insert({'email': email, 'name': name, 'password': password});
    // Constant.currentUser =
    //     UserModel(email: email, name: name, password: password);
    // sl
    //     .get<SharedPreferences>()
    //     .setString('currentUser', Constant.currentUser!.toJson());
    // widget.goToHomePage();
    // }  on AuthException catch (error) {
    //   changeButtonLoadingState(false);
    //   Toast.show(error.message, duration: 2);
    // } on SocketException {
    //   changeButtonLoadingState(false);
    //   Toast.show('Check your internet connection');
    // }
  }

  void changeButtonLoadingState(bool isLoading) {
    context
        .read<SignInLoadingBloc>()
        .add(ChangeLoadingState(isLoading: isLoading));
  }
}
