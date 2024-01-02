import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'featurs/main_page/data_source/data_source_paths.dart';

GetIt sl = GetIt.instance;
Future<void> init() async {
  sl.registerLazySingleton<RemoteDataSource>(() => RemoteDataSource());
  sl.registerLazySingleton<UpdateDeleteLocalDataSource>(
      () => UpdateDeleteLocalDataSource());
  sl.registerLazySingleton<SearchDataSource>(() => SearchDataSource());
  sl.registerLazySingleton<GetDataLocalDataSource>(
      () => GetDataLocalDataSource());
  sl.registerLazySingleton<SetDataLocalDataSource>(
      () => SetDataLocalDataSource());

  sl.registerLazySingleton<DataSource>(() => DataSource(
        updateDeleteLocalDataSource: sl.get<UpdateDeleteLocalDataSource>(),
        setDataLocalDataSource: sl.get<SetDataLocalDataSource>(),
        getDataLocalDataSource: sl.get<GetDataLocalDataSource>(),
        searchDataSource: sl.get<SearchDataSource>(),
        remoteDataSource: RemoteDataSource(),
      ));
  SharedPreferences db = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => db);
}
