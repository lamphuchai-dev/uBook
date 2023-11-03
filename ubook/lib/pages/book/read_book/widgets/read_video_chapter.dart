import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:ubook/data/models/chapter.dart';
import 'package:ubook/utils/system_utils.dart';

import '../cubit/read_book_cubit.dart';

class ReadVideoChapter extends StatefulWidget {
  const ReadVideoChapter({super.key, required this.chapter});
  final Chapter chapter;

  @override
  State<ReadVideoChapter> createState() => _ReadVideoChapterState();
}

class _ReadVideoChapterState extends State<ReadVideoChapter> {
  late final player = Player();
  // Create a [VideoController] to handle video output from [Player].
  late final controller = VideoController(player);
  late ReadBookCubit _readBookCubit;

  @override
  void initState() {
    super.initState();
    player.open(Media(widget.chapter.content.first));
    _readBookCubit = context.read<ReadBookCubit>();
  }

  @override
  void dispose() {
    player.dispose();
    SystemUtils.setPreferredOrientations();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialVideoControlsTheme(
      normal: MaterialVideoControlsThemeData(
          volumeGesture: true,
          seekBarMargin: const EdgeInsets.only(bottom: 60, left: 16, right: 16),
          brightnessGesture: true,
          // Modify theme options:
          buttonBarButtonSize: 24.0,
          buttonBarButtonColor: Colors.white,
          topButtonBarMargin: const EdgeInsets.only(top: 30),
          topButtonBar: [
            Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(widget.chapter.title)),
            const Spacer(),
            MaterialCustomButton(
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: Colors.white,
              ),
              onPressed: () async {
                Navigator.pop(context);
              },
            ),
          ],
          bottomButtonBar: [
            if (widget.chapter.index > 0)
              MaterialCustomButton(
                icon: const Icon(Icons.skip_previous_rounded),
                onPressed: () {
                  _readBookCubit.onPreviousChapter();
                },
              ),
            const MaterialPlayOrPauseButton(),
            if (widget.chapter.index > 0)
              MaterialCustomButton(
                icon: const Icon(Icons.skip_next_rounded),
                onPressed: () {
                  _readBookCubit.onNextChapter();
                },
              ),
            const MaterialPositionIndicator(),
            const Spacer(),
            MaterialCustomButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
                // _c.showPlayList.value = !_c.showPlayList.value;
              },
              icon: const Icon(Icons.list),
            ),
            const MaterialFullscreenButton()
          ]),
      fullscreen: const MaterialVideoControlsThemeData(
        seekBarMargin: EdgeInsets.only(bottom: 60, left: 16, right: 16),
      ),
      child: Video(
        controller: controller,
      ),
    );
  }
}
