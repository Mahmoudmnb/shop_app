import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'featurs/main_page/data_source/data_source.dart';
import 'featurs/main_page/data_source/local_data_source.dart';

GetIt sl = GetIt.instance;
Future<void> init() async {
  await ScreenUtil.ensureScreenSize();
  sl.registerLazySingleton<LocalDataSource>(() => LocalDataSource());

  sl.registerLazySingleton<DataSource>(
      () => DataSource(localDataSource: sl.get<LocalDataSource>()));

  SharedPreferences db = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => db);
}
