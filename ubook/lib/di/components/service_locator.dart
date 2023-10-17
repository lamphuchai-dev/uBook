import 'package:dio_client/index.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubook/services/extensions_service.dart';
import 'package:ubook/services/database_service.dart';
import 'package:ubook/services/storage_service.dart';

import '../../data/sharedpref/shared_preference_helper.dart';
import '../modules/local_module.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  getIt.registerSingletonAsync<SharedPreferences>(
      () => LocalModule.provideSharedPreferences());

  final storage = StorageService();
  await storage.ensureInitialized();
  getIt.registerSingleton(storage);

  getIt.registerSingleton(DioClient());
  final databaseService = DatabaseService();
  await databaseService.ensureInitialized();
  getIt.registerSingleton(databaseService);
  getIt.registerSingleton(
      SharedPreferenceHelper(await getIt.getAsync<SharedPreferences>()));

  getIt.registerSingleton(ExtensionsService());
}
