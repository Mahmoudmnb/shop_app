import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SocialButton extends StatelessWidget {
  const SocialButton({super.key, required this.onTap, required this.imageUrl});

  final void Function() onTap;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () async {
          // SupabaseClient supabase = Supabase.instance.client;
          // try {
          //   // var key = await supabase.auth.signInWithOAuth(Provider.github);
          //   // var key = await supabase.auth.signInWithOAuth(Provider.linkedin,
          //   //     context: context,
          //   //     authScreenLaunchMode: LaunchMode.platformDefault);
          //   var key = await supabase.auth.signInWithOAuth(Provider.google,
          //       context: context,
          //       authScreenLaunchMode: LaunchMode.platformDefault);
          //   final User? user = supabase.auth.currentUser;
          //   print(user);
          //   if (key) {
          //     goToHomePage();
          //   }
          //   // Constant.currentUser =
          //   //     UserModel(email: email, name: name, password: password);
          //   // SharedPreferences db = await SharedPreferences.getInstance();
          //   // db.setString('currentUser', Constant.currentUser!.toJson());
          // } on AuthException catch (error) {
          //   Toast.show(error.message, duration: 2);
          // } on SocketException {
          //   Toast.show('Check your internet connection');
          // }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Image.asset(
              imageUrl,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
