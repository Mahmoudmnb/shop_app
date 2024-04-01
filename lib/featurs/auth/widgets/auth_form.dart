import 'dart:developer';
import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/core/constant.dart';
import 'package:shop_app/core/internet_info.dart';
import 'package:shop_app/featurs/auth/models/user_model.dart';
import 'package:shop_app/injection.dart';
import 'package:toast/toast.dart';
import 'package:uuid/uuid.dart';

import '../../main_page/data_source/data_source_paths.dart';
import '../blocs/auth_blocs.dart';
import '../data.dart';
import 'auth_widgets.dart';

class AuthForm extends StatefulWidget {
  final Future<void> Function() goToHomePage;
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
    context.read<EmailTextBloc>().add(ChangeToInit());
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
                      bool isSuccess = await signUp(
                          email.trim(), password.trim(), name.trim());
                      if (isSuccess) {
                        await widget.goToHomePage();
                      }
                    } else {
                      bool isSuccess =
                          await signIn(email.trim(), password.trim());
                      if (isSuccess) {
                        await widget.goToHomePage();
                      }
                    }
                  } else {
                    Toast.show('Check you internet connection',
                        duration: Toast.lengthLong);
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
                      ? const CircularProgressIndicator(color: Colors.black)
                      : SwitchBetweenTwoTextWithRotation(
                          isFirestText: isSignUP,
                          firstText: 'LOG IN',
                          secondText: 'SIGN UP',
                          textStyle: TextStyle(
                              fontFamily: 'DM Sans',
                              fontSize: 16.sp,
                              color: Colors.white));
                },
              ),
            );
          },
        ),
        SizedBox(height: 8.5.h),
      ],
    );
  }

  Future<bool> signIn(String email, String password) async {
    bool isScuccess = false;
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
      //! this was for make sure no one had loged in before in other device
      // if (!data.documents[0].data['loged_in']) {
      if (true) {
        String fileName = Uuid().v1.toString();

        String name = data.documents[0].data['name'];
        if (data.documents[0].data['imgUrl'] != null) {
          Uint8List profileImage = Uint8List(0);
          var res = await sl
              .get<DataSource>()
              .downloadProfileImage(data.documents[0].data['imgUrl']);
          var s = res.fold((l) {
            profileImage = l;
            return true;
          }, (r) => false);
          if (!s) {
            return false;
          }
          await File('${Constant.baseUrl + fileName}.jpg')
              .writeAsBytes(profileImage);
        }
        Constant.currentUser = UserModel(
            phoneNumber: data.documents[0].data['phone_number'],
            email: email,
            name: name,
            password: password,
            cloudImgUrl: data.documents[0].data['imgUrl'],
            imgUrl: data.documents[0].data['imgUrl'] == null
                ? null
                : '${Constant.baseUrl + fileName}.jpg');
        sl
            .get<SharedPreferences>()
            .setString('currentUser', Constant.currentUser!.toJson());
        context.read<EmailTextBloc>().add(ChangeEmailText(emailText: ''));
        changeButtonLoadingState(false);
        log('done');
      }
      // else {
      //   Toast.show(
      //       'Sorry but this account is used in other device please log out for the other device and try again',
      //       duration: Toast.lengthLong);
      // }
      isScuccess = true;
    } on AppwriteException catch (e) {
      log(e.toString());
      if (e.message != null &&
          e.message!.contains('user_invalid_credentials')) {
        Toast.show('wrong email or password', duration: 2);
      } else if (e.message!.contains('Please check the email and password')) {
        Toast.show('invalid email or password please try again');
      } else {
        Toast.show('unkown error please try again');
      }
      changeButtonLoadingState(false);
      isScuccess = false;
    } on SocketException catch (_) {
      changeButtonLoadingState(false);
      Toast.show('Your internet is week please check your internet connection');
      isScuccess = false;
    } catch (e) {
      log(e.toString());
      Toast.show('Something went wrong please try again later');
      isScuccess = false;
    }
    return isScuccess;
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

  Future<bool> signUp(String email, String password, String name) async {
    bool isSuccess = false;
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
      context.read<EmailTextBloc>().add(ChangeEmailText(emailText: ''));
      changeButtonLoadingState(false);
      log('done log in');
      isSuccess = true;
    } on AppwriteException catch (e) {
      log(e.toString());
      if (e.toString().contains('user_already_exists')) {
        Toast.show('user already exists for this email');
      } else {
        Toast.show('unkown error please try again');
      }
      changeButtonLoadingState(false);
      isSuccess = false;
    } on SocketException {
      changeButtonLoadingState(false);
      Toast.show('Your internet is week please check your internet connection');
      isSuccess = false;
    } catch (e) {
      isSuccess = false;
      Toast.show('Something went wrong please try again later');
      log(e.toString());
    }
    return isSuccess;
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
