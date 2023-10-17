import 'package:hive_flutter/adapters.dart';
import 'package:ubook/utils/directory_utils.dart';
import 'package:ubook/utils/logger.dart';

class StorageService {
  final _logger = Logger("BookStorage");
  // late final Isar database;
  late final Box settings;
  late String _path;

  Future<void> ensureInitialized() async {
    _path = await DirectoryUtils.getDirectory;
    await Hive.initFlutter(_path);
    settings = await Hive.openBox("settings");

    _initSettings();
  }

  Future<void> _initSettings() async {
    _logger.log(_path);
  }

  Future<void> _initSetting(String key, dynamic value) async {
    if (!settings.containsKey(key)) {
      await settings.put(key, value);
    }
  }

  Future<void> setSetting(String key, dynamic value) async {
    await settings.put(key, value);
  }

  dynamic getSetting(String key) {
    return settings.get(key);
  }

  Future<String?> getSourceExtensionPrimary() async {
    final result = settings.get(SettingKey.sourceExtPrimary);
    if (result is String) return result;
    return null;
  }

  Future<void> setSourceExtensionPrimary(String source) async {
    await settings.put(SettingKey.sourceExtPrimary, source);
  }
}

class SettingKey {
  static String theme = "Theme";
  static String extension = "Extension";
  static String listExtension = "ListExtension";
  static String sourceExtPrimary = "SourceExtPrimary";
}
