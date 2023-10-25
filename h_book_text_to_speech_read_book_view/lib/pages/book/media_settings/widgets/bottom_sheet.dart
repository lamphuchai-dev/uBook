import 'package:flutter/material.dart';
import 'package:h_book/app/extensions/extensions.dart';
import 'package:h_book/di/service_locator.dart';
import 'package:h_book/services/text_to_speech_service.dart';
import 'package:h_book/widgets/widgets.dart';

class BottomSheetWidget extends StatefulWidget {
  const BottomSheetWidget({super.key});

  @override
  State<BottomSheetWidget> createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> {
  // late final ValueNotifier<String> _language;
  late final ValueNotifier<double> _speechRate;
  late final ValueNotifier<double> _pitch;
  late final ValueNotifier<Voice?> _voice = ValueNotifier(null);

  List<Voice> _voices = [];

  final text = getIt<TextToSpeechService>();
  @override
  void initState() {
    _voice.value = text.getVoice;
    // _language = ValueNotifier(text.getLanguage);
    _speechRate = ValueNotifier(text.getSpeechRate);
    _pitch = ValueNotifier(text.getPitch);
    _getVoices();

    super.initState();
  }

  Future<void> _getVoices() async {
    _voices = await text.getVoices();
    setState(() {});
  }

  void _set() {
    text.setVoice(_voices.first);
    _voice.value = _voices.first;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.appTextTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: BaseBottomSheetUi(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 16,
            ),
            // ValueListenableBuilder(
            //   valueListenable: _language,
            //   builder: (context, value, child) => ButtonDialogAnimationWidget(
            //     sizeDialog: Size(context.width * 0.5, 300),
            //     title: Row(
            //       children: [
            //         Expanded(
            //           flex: 1,
            //           child: Text(
            //             "Ngôn ngữ",
            //             style: textTheme.titleMedium,
            //           ),
            //         ),
            //         Expanded(
            //             flex: 2,
            //             child: Row(
            //               mainAxisAlignment: MainAxisAlignment.end,
            //               children: [
            //                 Text(
            //                   mapLanguage[value]!,
            //                   style: textTheme.bodyMedium,
            //                 ),
            //                 const Icon(Icons.arrow_drop_down_rounded)
            //               ],
            //             ))
            //       ],
            //     ),
            //     items: mapLanguage.entries
            //         .map((e) => ItemButton(
            //             selected: e.key == value, value: e.value, key: e.key))
            //         .toList(),
            //     onChanged: (value) async {
            //       _language.value = value.key;
            //       text.setLanguage(value.key);
            //       await _getVoices();
            //       _set();
            //     },
            //   ),
            // ),
            const SizedBox(
              height: 8,
            ),
            ValueListenableBuilder(
              valueListenable: _voice,
              builder: (context, value, child) => ButtonDialogAnimationWidget(
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
                              value?.name ?? "",
                              style: textTheme.bodyMedium,
                            ),
                            const Icon(Icons.arrow_drop_down_rounded)
                          ],
                        ))
                  ],
                ),
                items: _voices
                    .map((e) => ItemButton(
                        selected: e.name == value?.name,
                        value: e.name,
                        key: e.locale))
                    .toList(),
                onChanged: (value) {
                  _voice.value = Voice(locale: value.key, name: value.value);
                  text.setVoice(_voice.value!);
                },
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            ValueListenableBuilder(
              valueListenable: _speechRate,
              builder: (context, value, child) => _sliderControl(
                  textTheme: textTheme,
                  onChanged: (value) async {
                    _speechRate.value = value / 100;
                    await text.setSpeechRate(value / 100);
                  },
                  value: value * 100,
                  min: 0,
                  max: 100,
                  label: "Độ cao"),
            ),
            const SizedBox(
              height: 12,
            ),
            ValueListenableBuilder(
              valueListenable: _pitch,
              builder: (context, pitchValue, child) => _sliderControl(
                  textTheme: textTheme,
                  onChanged: (value) async {
                    _pitch.value = value / 100;
                    await text.setPitch(value / 100);
                  },
                  min: 50,
                  max: 200,
                  value: pitchValue * 100,
                  label: "Tốc độ"),
            ),
            const SizedBox(
              height: 16,
            ),
            SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () async {
                      final tmp = await text.getVoices();
                      print(tmp);
                    },
                    child: const Text("Nghe thử"))),
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
                      onChanged.call(value--);
                    },
                    icon: const Icon(
                      Icons.remove_circle_outline_rounded,
                      size: 30,
                    )),
                IconButton(
                    onPressed: () {
                      if (value > max) return;
                      onChanged.call(value++);
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
}

const Map<String, String> mapLanguage = {
  "hr-HR": "Croatian",
  "ko-KR": "Korean",
  "mr-IN": "Marathi",
  "ru-RU": "Russian",
  "zh-TW": "Chinese (Traditional)",
  "hu-HU": "Hungarian",
  "sw-KE": "Swahili",
  "th-TH": "Thai",
  "ur-PK": "Urdu",
  "nb-NO": "Norwegian",
  "da-DK": "Danish",
  "tr-TR": "Turkish",
  "et-EE": "Estonian",
  "pt-PT": "Portuguese (Portugal)",
  "vi-VN": "Vietnamese",
  "en-US": "English (US)",
  "sq-AL": "Albanian",
  "sv-SE": "Swedish",
  "ar": "Arabic",
  "su-ID": "Sundanese",
  "bn-BD": "Bengali (Bangladesh)",
  "bs-BA": "Bosnian",
  "gu-IN": "Gujarati",
  "kn-IN": "Kannada",
  "el-GR": "Greek",
  "hi-IN": "Hindi",
  "he-IL": "Hebrew",
  "fi-FI": "Finnish",
  "bn-IN": "Bengali (India)",
  "km-KH": "Khmer",
  "fr-FR": "French",
  "uk-UA": "Ukrainian",
  "pa-IN": "Punjabi (India)",
  "en-AU": "English (Australia)",
  "nl-NL": "Dutch",
  "fr-CA": "French (Canada)",
  "lv-LV": "Latvian",
  "sr": "Serbian",
  "pt-BR": "Portuguese (Brazil)",
  "de-DE": "German",
  "ml-IN": "Malayalam",
  "si-LK": "Sinhala",
  "cs-CZ": "Czech",
  "is-IS": "Icelandic",
  "pl-PL": "Polish",
  "ca-ES": "Catalan",
  "sk-SK": "Slovak",
  "it-IT": "Italian",
  "fil-PH": "Filipino",
  "lt-LT": "Lithuanian",
  "ne-NP": "Nepali",
  "ms-MY": "Malay",
  "en-NG": "English (Nigeria)",
  "nl-BE": "Dutch (Belgium)",
  "zh-CN": "Chinese (Simplified)",
  "es-ES": "Spanish (Spain)",
  "ja-JP": "Japanese",
  "ta-IN": "Tamil (India)",
  "bg-BG": "Bulgarian",
  "cy-GB": "Welsh",
  "yue-HK": "Cantonese (Hong Kong)",
  "es-US": "Spanish (United States)",
  "en-IN": "English (India)",
  "jv-ID": "Javanese",
  "id-ID": "Indonesian",
  "te-IN": "Telugu (India)",
  "ro-RO": "Romanian",
  "en-GB": "English (United Kingdom)"
};


