import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/core/constant.dart';
import 'package:shop_app/featurs/auth/models/user_model.dart';
import 'package:shop_app/injection.dart';

class PersonalDetails extends StatefulWidget {
  const PersonalDetails({super.key});

  @override
  State<PersonalDetails> createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  String? imgUrl;
  @override
  void initState() {
    fullNameController.text = Constant.currentUser!.name;
    phoneNumberController.text = Constant.currentUser!.phoneNumber ?? '';
    emailController.text = Constant.currentUser!.email;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    fullNameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 60.h),
          child: Column(children: [
            Row(
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Image(
                      height: 40.w,
                      width: 40.w,
                      image: const AssetImage("assets/images/backicon.png"),
                    )),
                SizedBox(width: 8.w),
                Text(
                  "Personal Details",
                  style: TextStyle(fontSize: 18.sp, fontFamily: 'Tenor Sans'),
                )
              ],
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                const Spacer(),
                Stack(
                  alignment: const Alignment(1.2, 1.2),
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(12)),
                      child: Constant.currentUser!.imgUrl == null
                          ? const SizedBox(
                              height: 130,
                              width: 130,
                              child: Center(
                                child: Text(
                                  'No Image',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            )
                          : Image(
                              height: 130.h,
                              width: 130.h,
                              image: const AssetImage('assets/images/1.png')),
                    ),
                    GestureDetector(
                      onTap: () async {
                        // Todo : code for select an image for profile
                        ImagePicker imagePicker = ImagePicker();
                        XFile? file = await imagePicker.pickImage(
                            source: ImageSource.gallery);
                        if (file != null) {
                          try {
                            File profileImage = await File(file.path).copy(
                                '/data/user/0/com.example.shop_app/mnb.jpg');
                            Constant.currentUser!.imgUrl = profileImage.path;
                            sl.get<SharedPreferences>().setString(
                                'currentUser', Constant.currentUser!.toJson());
                            log(Constant.currentUser!.imgUrl!);
                          } catch (e) {
                            log(e.toString());
                          }
                        } else {
                          log('empty image');
                        }
                      },
                      child: Container(
                        height: 40.h,
                        width: 40.h,
                        padding: EdgeInsets.only(top: 8.h),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                offset: const Offset(0, 4),
                                color: Colors.black.withOpacity(.25),
                                blurRadius: 4,
                              )
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: const Image(
                            image: AssetImage("assets/images/Pen.png")),
                      ),
                    )
                  ],
                ),
                const Spacer(),
              ],
            ),
            SizedBox(height: 80.h),
            const Row(
              children: [
                Expanded(
                    child: Text(
                  "Full Name",
                  style: TextStyle(
                      color: Color(0xFFA5A5A5), fontFamily: 'DM Sans'),
                )),
              ],
            ),
            SizedBox(
                width: 393.w,
                height: 50.h,
                child: TextField(
                  onTapOutside: (value) {
                    FocusScope.of(context).unfocus();
                  },
                  controller: fullNameController,
                )),
            SizedBox(height: 24.h),
            const SizedBox(
              width: double.infinity,
              child: Text(
                "Email",
                textAlign: TextAlign.start,
                style:
                    TextStyle(color: Color(0xFFA5A5A5), fontFamily: 'DM Sans'),
              ),
            ),
            TextField(
              onTapOutside: (value) {
                FocusScope.of(context).unfocus();
              },
              controller: emailController,
            ),
            SizedBox(height: 25.h),
            const Row(
              children: [
                Expanded(
                    child: Text(
                  "Phone Number",
                  style: TextStyle(
                      color: Color(0xFFA5A5A5), fontFamily: 'DM Sans'),
                )),
              ],
            ),
            SizedBox(
                height: 50.h,
                width: 393.w,
                child: TextField(
                  onTapOutside: (value) {
                    FocusScope.of(context).unfocus();
                  },
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                      hintStyle: const TextStyle(color: Colors.grey),
                      hintText: phoneNumberController.text == ''
                          ? 'No Phone number'
                          : ''),
                  controller: phoneNumberController,
                )),
            SizedBox(height: 80.h),
            InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () async {
                UserModel user = UserModel(
                    phoneNumber: phoneNumberController.text != ''
                        ? phoneNumberController.text.trim()
                        : null,
                    imgUrl: imgUrl,
                    email: emailController.text.trim(),
                    name: fullNameController.text.trim(),
                    password: Constant.currentUser!.password);

                Constant.currentUser = user;
                await sl
                    .get<SharedPreferences>()
                    .setString('currentUser', user.toJson());
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              child: Ink(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 13.h),
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10)),
                child: Text(
                  "Save",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'DM Sans',
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
