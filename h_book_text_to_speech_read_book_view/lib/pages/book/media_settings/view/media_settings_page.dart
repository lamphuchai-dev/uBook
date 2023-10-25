// ignore_for_file: public_member_api_docs, sort_constructors_first, no_leading_underscores_for_local_identifiers
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:h_book/app/extensions/context_extension.dart';
import 'package:h_book/utils/dialog_state_mixin.dart';

import '../cubit/media_settings_cubit.dart';
import '../widgets/bottom_sheet.dart';
import '../widgets/text_to_speech_settings_widget.dart';

class MediaSettingsPage extends StatefulWidget {
  const MediaSettingsPage({super.key});

  @override
  State<MediaSettingsPage> createState() => _MediaSettingsPageState();
}

class _MediaSettingsPageState extends State<MediaSettingsPage>
    with DialogStateMixin {
  late MediaSettingsCubit _mediaSettingsCubit;

  GlobalKey key = GlobalKey();
  @override
  void initState() {
    _mediaSettingsCubit = context.read<MediaSettingsCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.appTextTheme;

    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text("Cài đặt giọng đọc")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            // ElevatedButton(
            //     onPressed: () {
            //       showModalBottomSheet(
            //         context: context,
            //         isScrollControlled: true,
            //         builder: (context) => const BottomSheetWidget(),
            //       );
            //     },
            //     child: const Text("Show bottom sheet")),
            ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => const TextToSpeechSettingsWidget(),
                  );
                },
                child: const Text("Show bottom sheet")),
          ],
        ),
      ),
    );
  }
}
