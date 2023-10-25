import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:h_book/data/models/json_me.dart';
import 'package:h_book/data/models/plugin.dart';
import 'package:h_book/services/storage_service.dart';
import 'package:h_book/services/text_to_speech_service.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  final storage = StorageService();
  await storage.ensureInitialized();
  getIt.registerSingleton(storage);
  final textToSpeechService = TextToSpeechService(storageService: storage);
  // textToSpeechService.onInit();
  getIt.registerSingleton(textToSpeechService);
  final data = json.encode(masterTest);
  final jsonData = json.decode(data);
  final plugin = BookPlugin.fromMap(jsonData);
  getIt.registerSingleton(plugin);
}
