// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'package:h_book/app/constants/app_type.dart';
import 'package:h_book/app/constants/lang.dart';
import 'package:h_book/data/models/models.dart';
import 'package:h_book/services/storage_service.dart';
import 'package:h_book/utils/logger.dart';

class TextToSpeechService {
  TextToSpeechService({required StorageService storageService})
      : _storageService = storageService;

  final StorageService _storageService;
  final _logger = Logger("TextToSpeechService");
  late final FlutterTts _flutterTts;

  late Language _language;
  late Voice _voice;
  late double _pitch;
  late double _speechRate;

  Voice get getVoice => _voice;
  Language get getLanguage => _language;
  double get getPitch => _pitch;
  double get getSpeechRate => _speechRate;

  List<Chapter> _chapters = [];
  List<Chapter> get getChapters => _chapters;
  set setChapters(List<Chapter> chapters) => _chapters = chapters;

  late Chapter currentReadChapter;
  List<String> _listTextSpeak = [];
  int _indexReadingChapter = 0;
  int _indexTextSpeak = 0;
  bool _testSpeech = false;

  ValueChanged<Chapter>? onStartChapter;
  Future<bool> Function(Chapter chapter)? onNextChapter;
  Future<bool> Function(Chapter chapter)? onPreviousChapter;

  ValueChanged<Chapter>? onCompleteChapter;
  VoidCallback? onReadDoneChapters;

  late final StreamController<MediaStatus> _mediaStatusStreamController;

  Stream<MediaStatus> get mediaStatusChange =>
      _mediaStatusStreamController.stream;

  late final StreamController<MediaProgress> _progressMediaStreamController;

  Stream<MediaProgress> get progressMedia =>
      _progressMediaStreamController.stream;

  List<String> _getListContentByChapter(Chapter chapter) =>
      chapter.content.split("\n");

  bool _handlerStop = false;

  Future<void> onInit() async {
    _flutterTts = FlutterTts();
    _mediaStatusStreamController = StreamController.broadcast(sync: true);
    _progressMediaStreamController = StreamController.broadcast();
    _flutterTts.setStartHandler(_handlerStartSpeak);
    _flutterTts.setPauseHandler(_handlerPauseSpeak);
    _flutterTts.setCancelHandler(_handlerStopSpeak);
    _flutterTts.setErrorHandler(_handlerErrorSpeak);
    _flutterTts.setCompletionHandler(_handlerCompleteSpeak);
    _flutterTts.setProgressHandler(_handlerProgressSpeak);

    if (Platform.isIOS) {
      await _flutterTts.setSharedInstance(true);
      await _flutterTts.setIosAudioCategory(
          IosTextToSpeechAudioCategory.playback,
          [
            IosTextToSpeechAudioCategoryOptions.allowBluetooth,
            IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
            IosTextToSpeechAudioCategoryOptions.mixWithOthers,
            IosTextToSpeechAudioCategoryOptions.defaultToSpeaker
          ],
          IosTextToSpeechAudioMode.defaultMode);
    }
    await _loadLocal();
  }

  Future<void> _loadLocal() async {
    final localeLanguage = _storageService.getSetting(SettingKey.languageTTS);

    await setLanguage(Language(
        locale: localeLanguage,
        name: mapLanguage[localeLanguage] ?? localeLanguage));
    final localVoice = _storageService.getSetting(SettingKey.voiceTTS);
    if (localVoice != null) {
      await setVoice(Voice.fromMap(Map.from(localVoice)));
    } else {
      final voices = await getVoices();
      await setVoice(voices.first);
    }
    _pitch = _storageService.getSetting(SettingKey.pitchTTS);
    await setPitch(_pitch);
    _speechRate = _storageService.getSetting(SettingKey.speechRateTTS);
    await setSpeechRate(_speechRate);
  }

  void _handlerProgressSpeak(
      String text, int startOffset, int endOffset, String word) {
    if (_testSpeech) return;
    _progressMediaStreamController
        .add(MediaProgress(text, startOffset, endOffset, word));
  }

  void _handlerStartSpeak() {
    // _mediaStatusStreamController.add(MediaStatus.play);
  }

  void _handlerCompleteSpeak() async {
    if (_testSpeech) return;
    if (_indexTextSpeak >= _listTextSpeak.length - 1) {
      // Thông báo đã đọc xong 1 chapter
      onCompleteChapter?.call(_chapters[_indexReadingChapter]);
      _mediaStatusStreamController.add(MediaStatus.complete);
      _indexReadingChapter += 1; // đọc chapter Tiếp theo
      if (_indexReadingChapter >= _chapters.length) {
        // Thông báo đã đọc xong tất cả chapter
        onReadDoneChapters?.call();
      } else {
        if (onNextChapter == null) {
          onReadDoneChapters?.call();
          return;
        }
        final isNextPage =
            await onNextChapter?.call(_chapters[_indexReadingChapter]);
        if (isNextPage != null && isNextPage) {
          final result = await onStart(_indexReadingChapter);
        } else {
          onReadDoneChapters?.call();
        }
      }
    } else {
      // Đọc text tiếp theo trong list text
      _indexTextSpeak += 1;
      final result = await _flutterTts.speak(_listTextSpeak[_indexTextSpeak]);
    }
  }

  void _handlerPauseSpeak() {
    _mediaStatusStreamController.add(MediaStatus.pause);
  }

  void _handlerStopSpeak() {
    if (_handlerStop || _testSpeech) return;
    _mediaStatusStreamController.add(MediaStatus.stop);
  }

  void _handlerErrorSpeak(dynamic message) {}

  Future<bool> onStart(int indexChapter,
      {int? indexText, bool? lastIndex}) async {
    try {
      _indexReadingChapter = indexChapter;
      _indexTextSpeak = 0;
      _testSpeech = false;
      if (indexText != null) _indexTextSpeak = indexText;

      _listTextSpeak =
          _getListContentByChapter(_chapters[_indexReadingChapter]);
      if (lastIndex != null) _indexTextSpeak = _listTextSpeak.length - 1;

      final result = await _flutterTts.speak(_listTextSpeak[_indexTextSpeak]);
      if (result == 1) {
        if (_indexTextSpeak == 0) {
          onStartChapter?.call(_chapters[_indexReadingChapter]);
        }

        return true;
      }
    } catch (error) {
      _logger.error(error);
    }
    return false;
  }

  Future<bool> onPlay() async {
    try {
      final result = await _flutterTts.speak(_listTextSpeak[_indexTextSpeak]);
      if (result == 1) {
        _mediaStatusStreamController.add(MediaStatus.start);
        _handlerStop = false;
        _testSpeech = false;
        return true;
      }
    } catch (error) {
      _logger.error(error);
    }
    return false;
  }

  Future<bool> onPause() async {
    try {
      final result = await _flutterTts.pause();
      return result == 1 ? true : false;
    } catch (error) {
      _logger.error(error);
    }
    return false;
  }

  Future<bool> onStop() async {
    try {
      final result = await _flutterTts.stop();
      return result == 1 ? true : false;
    } catch (error) {
      _logger.error(error);
    }
    return false;
  }

  Future<bool> onSkipNext() async {
    if (onNextChapter != null && _indexReadingChapter + 1 < _chapters.length) {
      final result =
          await onNextChapter?.call(_chapters[_indexReadingChapter + 1]);
      if (result != null && result) {
        _handlerStop = true;
        await onStop();
        return onStart(_indexReadingChapter + 1);
      }
    }
    return false;
  }

  Future<bool> onSkipPrevious() async {
    if (onNextChapter != null && _indexReadingChapter - 1 >= 0) {
      final result =
          await onPreviousChapter?.call(_chapters[_indexReadingChapter - 1]);
      if (result != null && result) {
        _handlerStop = true;
        await onStop();
        return onStart(_indexReadingChapter - 1, lastIndex: true);
      }
    }
    return false;
  }

  Future<bool> onFastForwardMedia() async {
    if (_indexTextSpeak + 1 < _listTextSpeak.length) {
      _handlerStop = true;
      _indexTextSpeak += 1;
      await onStop();
      return onPlay();
    }
    return await onSkipNext();
  }

  Future<bool> onFastRewindMedia() async {
    if (_indexTextSpeak - 2 >= 0) {
      _handlerStop = true;
      _indexTextSpeak = _indexTextSpeak - 2;
      await onStop();
      return onPlay();
    }
    return await onSkipPrevious();
  }

  // Future<List<String>> getLanguages() async {
  //   List<String> result = [];
  //   try {
  //     final list = await _flutterTts.getLanguages;
  //     if (list is List<String>) {
  //       result = List.from(list);
  //       return result;
  //     }
  //   } catch (error) {
  //     _logger.error(error);
  //   }
  //   return result;
  // }

  Future<List<Language>> getLanguages() async {
    List<Language> result = [];
    try {
      final list = await _flutterTts.getLanguages;
      if (list is List) {
        result = list
            .map((e) => Language(locale: e, name: mapLanguage[e] ?? e))
            .toList();
        return result;
      }
    } catch (error) {
      _logger.error(error);
    }
    return result;
  }

  Future<bool> setLanguage(Language language) async {
    try {
      final result = await _flutterTts.setLanguage(language.locale);
      if (result == 1) {
        _language = language;
        _logger.log("setLanguage : $language");
        await _storageService.setSetting(
            SettingKey.languageTTS, language.locale);

        return true;
      }
      return false;
    } catch (error) {
      _logger.error(error);
    }
    return false;
  }

  Future<List<Voice>> getVoices() async {
    List<Voice> result = [];
    try {
      final list = await _flutterTts.getVoices;

      if (list is List) {
        result = list.map((e) => Voice.fromMap(Map.from(e))).toList();
        return result
            .where((element) => element.locale == _language.locale)
            .toList();
      }
    } catch (error) {
      _logger.error(error);
    }
    return result;
  }

  Future<bool> setVoice(Voice voice) async {
    try {
      final result = await _flutterTts.setVoice(voice.toMap());
      if (result == 1) {
        _voice = voice;
        _logger.log("setVoice : ${voice.toString()}");
        _storageService.setSetting(SettingKey.voiceTTS, voice.toMap());
        return true;
      }
      return false;
    } catch (error) {
      _logger.error(error);
    }
    return false;
  }

  Future<bool> setPitch(double pitch) async {
    try {
      final result = await _flutterTts.setPitch(pitch);
      if (result == 1) {
        _pitch = pitch;
        _logger.log("setPitch : $pitch");
        await _storageService.setSetting(SettingKey.pitchTTS, pitch);

        return true;
      }
      return false;
    } catch (error) {
      _logger.error(error);
    }
    return false;
  }

  Future<bool> setSpeechRate(double rate) async {
    try {
      final result = await _flutterTts.setSpeechRate(rate);
      if (result == 1) {
        _speechRate = rate;
        _logger.log("setSpeechRate : $rate");
        await _storageService.setSetting(SettingKey.speechRateTTS, rate);
        return true;
      }
      return false;
    } catch (error) {
      _logger.error(error);
    }
    return false;
  }

  Future<void> onTestSpeech() async {
    if (_listTextSpeak.isNotEmpty) {
      _testSpeech = true;
      _flutterTts.speak(_listTextSpeak.first);
    }
  }
}

class Voice {
  final String locale;
  final String name;
  Voice({
    required this.locale,
    required this.name,
  });

  Voice copyWith({
    String? locale,
    String? name,
  }) {
    return Voice(
      locale: locale ?? this.locale,
      name: name ?? this.name,
    );
  }

  Map<String, String> toMap() {
    return <String, String>{
      'locale': locale,
      'name': name,
    };
  }

  factory Voice.fromMap(Map<String, dynamic> map) {
    return Voice(
      locale: map['locale'] as String,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Voice.fromJson(String source) =>
      Voice.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Voice(locale: $locale, name: $name)';

  @override
  bool operator ==(covariant Voice other) {
    if (identical(this, other)) return true;

    return other.locale == locale && other.name == name;
  }

  @override
  int get hashCode => locale.hashCode ^ name.hashCode;
}

class MediaProgress extends Equatable {
  final String text;
  final int startOffset;
  final int endOffset;
  final String word;
  const MediaProgress(
    this.text,
    this.startOffset,
    this.endOffset,
    this.word,
  );

  @override
  String toString() {
    return 'ProgressSpeak(text: $text, startOffset: $startOffset, endOffset: $endOffset, word: $word)';
  }

  @override
  List<Object?> get props => [text, startOffset, endOffset, word];
}

class Language {
  final String locale;
  final String name;
  Language({
    required this.locale,
    required this.name,
  });

  Language copyWith({
    String? locale,
    String? name,
  }) {
    return Language(
      locale: locale ?? this.locale,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'locale': locale,
      'name': name,
    };
  }

  factory Language.fromMap(Map<String, dynamic> map) {
    return Language(
      locale: map['locale'] as String,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Language.fromJson(String source) =>
      Language.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Language(locale: $locale, name: $name)';

  @override
  bool operator ==(covariant Language other) {
    if (identical(this, other)) return true;

    return other.locale == locale && other.name == name;
  }

  @override
  int get hashCode => locale.hashCode ^ name.hashCode;
}
