import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_iframe/flutter_html_iframe.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:ubook/app/extensions/index.dart';
import 'package:ubook/data/models/chapter.dart';
import 'package:ubook/utils/system_utils.dart';

import '../cubit/read_book_cubit.dart';

class ReadVideoChapter extends StatefulWidget {
  const ReadVideoChapter({super.key, required this.chapter,required this.widthScreen});
  final Chapter chapter;
  final double widthScreen;

  @override
  State<ReadVideoChapter> createState() => _ReadVideoChapterState();
}

class _ReadVideoChapterState extends State<ReadVideoChapter> {
  late final player = Player();
  // Create a [VideoController] to handle video output from [Player].
  late final controller = VideoController(player);
  late ReadBookCubit _readBookCubit;

  bool _videoMedia = true;
  Widget? _iframeHtml;
  @override
  void initState() {
    if (widget.chapter.content.length == 2) {
      _videoMedia = false;
      _iframeHtml = Html(
        data:
            '<iframe  src="${widget.chapter.content.first}" width="${widget.widthScreen}" height="${(widget.widthScreen / 16) * 9}"></iframe>',
        extensions: const [
          IframeHtmlExtension(),
        ],
      );
    } else {
      _videoMedia = true;
      player.open(Media(widget.chapter.content.first));
    }
    _readBookCubit = context.read<ReadBookCubit>();
    super.initState();
  }

  @override
  void dispose() {
    player.dispose();
    SystemUtils.setPreferredOrientations();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_videoMedia) {
      return MaterialVideoControlsTheme(
        normal: MaterialVideoControlsThemeData(
            volumeGesture: true,
            seekBarMargin:
                const EdgeInsets.only(bottom: 60, left: 16, right: 16),
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

    return Container(
      alignment: Alignment.center,
      child: _iframeHtml,
    );
  }
}
