import 'package:dio_client/index.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubook/services/download_service.dart';
import 'package:ubook/services/extensions_service.dart';
import 'package:ubook/services/database_service.dart';
import 'package:ubook/services/js_runtime.dart';
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

  final databaseService = DatabaseService();
  await databaseService.ensureInitialized();
  getIt.registerSingleton(databaseService);

  final dioClient = DioClient();
  getIt.registerSingleton(dioClient);
  final jsRuntime = JsRuntime(dioClient: dioClient);
  await jsRuntime.initRuntime();

  getIt.registerSingleton(jsRuntime);

  getIt.registerSingleton(
      SharedPreferenceHelper(await getIt.getAsync<SharedPreferences>()));

  final extensionService = ExtensionsService(dioClient: dioClient);
  getIt.registerSingleton(extensionService);

  final downloadService = DownloadService(
      jsRuntime: jsRuntime,
      databaseService: databaseService,
      extensionsService: extensionService);

  downloadService.onInit();
  getIt.registerSingleton(downloadService);
}
