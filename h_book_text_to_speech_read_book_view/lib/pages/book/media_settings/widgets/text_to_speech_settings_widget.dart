import 'dart:async';

import 'package:flutter/material.dart';
import 'package:h_book/app/extensions/extensions.dart';
import 'package:h_book/di/service_locator.dart';
import 'package:h_book/services/text_to_speech_service.dart';
import 'package:h_book/widgets/widgets.dart';

class TextToSpeechSettingsWidget extends StatefulWidget {
  const TextToSpeechSettingsWidget({super.key});

  @override
  State<TextToSpeechSettingsWidget> createState() =>
      _TextToSpeechSettingsWidgetState();
}

class _TextToSpeechSettingsWidgetState
    extends State<TextToSpeechSettingsWidget> {
  late final TextToSpeechService _textToSpeechService;

  late Language _currentLanguage;
  late Voice _currentVoice;
  late double _currentPitch;
  late double _currentSpeechRate;

  List<Language> _languages = [];
  List<Voice> _voices = [];

  Timer? _pitchTimer;
  Timer? _speechRateTimer;

  void _onInit() async {
    // await _textToSpeechService.onInit();
    _currentLanguage = _textToSpeechService.getLanguage;
    _currentVoice = _textToSpeechService.getVoice;
    _currentPitch = _textToSpeechService.getPitch;
    _currentSpeechRate = _textToSpeechService.getSpeechRate;
    _languages = await _textToSpeechService.getLanguages();
    _voices = await _textToSpeechService.getVoices();
    setState(() {});
  }

  @override
  void initState() {
    _textToSpeechService = getIt<TextToSpeechService>();
    _onInit();
    super.initState();
  }

  Future<void> _getVoicesByLanguage() async {
    final result = await _textToSpeechService.getVoices();
    if (result.isNotEmpty) {
      _voices = result;
      _onChangeVoice(_voices.first);
    }
  }

  Future<void> _onChangeVoice(Voice voice) async {
    final result = await _textToSpeechService.setVoice(voice);
    if (result) {
      setState(() {
        _currentVoice = voice;
      });
    }
  }

  void _handlerOnChangeLanguage(Language language) async {
    final result = await _textToSpeechService.setLanguage(language);
    if (result) {
      _currentLanguage = language;
      await _getVoicesByLanguage();
    }
  }

  void _handlerOnChangePitch(double value) {
    setState(() {
      _currentPitch = value / 100;
    });
    if (_pitchTimer != null) _pitchTimer?.cancel();
    _pitchTimer = Timer(const Duration(milliseconds: 200), () async {
      await _textToSpeechService.setPitch(value / 100);
      _currentPitch = _textToSpeechService.getPitch;
    });
  }

  void _handlerOnChangeSpeechRate(double value) {
    setState(() {
      _currentSpeechRate = value / 100;
    });
    if (_speechRateTimer != null) _speechRateTimer?.cancel();
    _speechRateTimer = Timer(const Duration(milliseconds: 200), () async {
      await _textToSpeechService.setSpeechRate(value / 100);
      _currentSpeechRate = _textToSpeechService.getSpeechRate;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.appTextTheme;

    return BaseBottomSheetUi(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            ButtonDialogAnimationWidget(
              sizeDialog: Size(context.width * 0.5, 300),
              title: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      "Ngôn ngữ",
                      style: textTheme.titleMedium,
                    ),
                  ),
                  Expanded(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            _currentLanguage.name,
                            style: textTheme.bodyMedium,
                          ),
                          const Icon(Icons.arrow_drop_down_rounded)
                        ],
                      ))
                ],
              ),
              items: _languages
                  .map((e) => ItemButton(
                      selected: e.locale == _currentLanguage.locale,
                      value: e.name,
                      key: e.locale))
                  .toList(),
              onChanged: (value) async {
                _handlerOnChangeLanguage(
                    Language(locale: value.key, name: value.value));
              },
            ),
            const SizedBox(
              height: 12,
            ),
            ButtonDialogAnimationWidget(
              sizeDialog: Size(context.width * 0.5, 300),
              title: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      "Giọng đọc",
                      style: textTheme.titleMedium,
                    ),
                  ),
                  Expanded(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            _currentVoice.name,
                            style: textTheme.bodyMedium,
                          ),
                          const Icon(Icons.arrow_drop_down_rounded)
                        ],
                      ))
                ],
              ),
              items: _voices
                  .map((e) => ItemButton(
                      selected: e.name == _currentVoice.name,
                      value: e.name,
                      key: e.locale))
                  .toList(),
              onChanged: (value) async {
                await _onChangeVoice(
                    Voice(locale: value.key, name: value.value));
              },
            ),
            const SizedBox(
              height: 12,
            ),
            _sliderControl(
                textTheme: textTheme,
                onChanged: _handlerOnChangePitch,
                min: 50,
                max: 200,
                value: _currentPitch * 100,
                label: "Độ cao giọng"),
            const SizedBox(
              height: 12,
            ),
            _sliderControl(
                textTheme: textTheme,
                onChanged: _handlerOnChangeSpeechRate,
                value: _currentSpeechRate * 100,
                min: 0,
                max: 100,
                label: "Tốc độ nói"),
            const SizedBox(
              height: 12,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(20, 56),
                      textStyle: textTheme.titleMedium),
                  onPressed: () {
                    _textToSpeechService.onTestSpeech();
                  },
                  child: const Text("Nghe Thử")),
            ),
            const SizedBox(
              height: 24,
            ),
          ],
        ),
      ),
    );
  }

  PhysicalModel _sliderControl({
    required TextTheme textTheme,
    required ValueChanged<double> onChanged,
    required double value,
    required String label,
    double min = 0.0,
    double max = 1.0,
  }) {
    return PhysicalModel(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      elevation: 0.3,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    label,
                    style: textTheme.titleMedium,
                  ),
                  Text(
                    value.toInt().toString(),
                    style: textTheme.titleMedium,
                  )
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                    child: Slider(
                  value: value,
                  max: max,
                  min: min,
                  onChanged: onChanged,
                )),
                IconButton(
                    onPressed: () {
                      if (value < min) return;
                      onChanged.call(value -= 1);
                    },
                    icon: const Icon(
                      Icons.remove_circle_outline_rounded,
                      size: 30,
                    )),
                IconButton(
                    onPressed: () {
                      if (value > max) return;
                      onChanged.call(value += 1);
                    },
                    icon: const Icon(
                      Icons.add_circle_outline_rounded,
                      size: 30,
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _speechRateTimer?.cancel();
    _pitchTimer?.cancel();
    _textToSpeechService.onStop();
    super.dispose();
  }
}
