import 'package:internet_connection_checker/internet_connection_checker.dart';

class InternetInfo {
  static Future<bool> isconnected() async {
    InternetConnectionChecker netInfo = InternetConnectionChecker();
    return netInfo.hasConnection;
  }
}
