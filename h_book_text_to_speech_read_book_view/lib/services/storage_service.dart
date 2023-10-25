import 'package:h_book/utils/logger.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:isar/isar.dart';

import '../utils/book_directory.dart';

class StorageService {
  final _logger = Logger("BookStorage");
  late final Isar database;
  late final Box settings;
  late String _path;

  Future<void> ensureInitialized() async {
    _path = await BookDirectory.getDirectory;
    await Hive.initFlutter(_path);
    settings = await Hive.openBox("settings");
    _initSettings();
  }

  Future<void> _initSettings() async {
    await _initSetting(SettingKey.theme, "system");
    await _initSetting(SettingKey.languageTTS, "vi-VN");
    await _initSetting(SettingKey.speechRateTTS, 1.0);
    await _initSetting(SettingKey.pitchTTS, 1.0);
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

  getSetting(String key) {
    return settings.get(key);
  }
}

class SettingKey {
  static String theme = "Theme";
  static String languageTTS = "LanguageTTS";
  static String speechRateTTS = "SpeechRateTTS";
  static String pitchTTS = "PitchTTS";
  static String voiceTTS = "VoiceTTS";
}
